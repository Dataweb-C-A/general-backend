class GenerateDrawPlacesJob < ApplicationJob 
  def generate(draw_id)
    draw = Draw.find_by(id: draw_id)

    return unless draw

    ActiveRecord::Base.transaction do
      if draw.places.count >= 1
        logger.info 'Cannot generate tickets for this draw, tickets already generated!'
        ActiveRecord::Rollback
        return
      end
    end
    if draw.draw_type == 'To-Infinity'
      puts 'To-Infinity Draw, no tickets generated!'
      return draw
    else
      GenerateDrawPlacesService.new(draw).call
      GenerateDrawPlacesService.new(draw).create_winner_place
      return draw
    end
  end

  def destroy(draw_id)
    redis = Redis.new
    Draw.find(draw_id).destroy
    redis.del("places:#{draw_id}")
  end

  def update(draw_id, *draw_params)
    Draw.find(draw_id).update(draw_params)
  end

  def sell_places(draw_id, place_positions, agency_id)
    redis = Redis.new
    @draw = Draw.find(draw_id)
  
    return unless @draw
  
    if @draw.is_active == false
      puts '¡Sorteo vencido!'
      return
    else
      places = JSON.parse(redis.get("places:#{draw_id}"))
  
      places_to_insert = []
  
      place_positions.each do |position|
        if position > places.length || position < 1
          puts "El lugar #{position} no existe."
          return {
            error: "El lugar #{position} ya está vendido.",
            completed: false
          }
        end
  
        place = places[position - 1]
  
        if place['is_sold']
          puts "El lugar #{position} ya está vendido."
          return {
            error: "El lugar #{position} ya está vendido.",
            completed: false
          }
        end
  
        place['is_sold'] = true
        # place['client'] = client_data
  
        puts "Lugar #{position} vendido correctamente."
        return {
          error: nil,
          completed: true
        }
      end

      places_to_insert << {
        draw_id: draw_id,
        place_numbers: place_positions,
        agency_id: @draw.owner_id,
        sold_at: DateTime.now,
      }
  
      if places_to_insert.present?
        if Place.where(draw_id: @draw.id, place_numbers: place_positions).length == 0
          Place.insert_all(places_to_insert)
          # Declare a variable to get de created Place
          created_places = Place.where(draw_id: draw_id, place_numbers: place_positions)
    
          if Whitelist.find_by(user_id: agency_id).role == 'Auto'
            Inbox.create(
              message: "Monto: #{place_positions.length * @draw.price_unit} \n Numeros: #{place_positions} \n Premio: #{@draw.first_prize} \n Tipo: #{@draw.type_of_draw} \n Agencia: #{Whitelist.find_by(user_id: @draw.owner_id).name} \n Tipo sorteo: #{@draw.draw_type} \n Fecha limite: #{@draw.expired_date == nil ? 'Por anunciar' : @draw.expired_date}",
              request_type: "Auto",
              whitelist_id: Whitelist.where(name: Whitelist.find_by(user_id: agency_id).name).first.id
            )
          end

          redis.del("places:#{draw_id}")
          redis.set("places:#{draw_id}", places.to_json)
        end 
      else
        puts 'No se encontraron lugares para vender.'
      end
    end
  end  
end

# +---------------------------------------------------------------------------------------------------------------------------------------------------------------+
# |------------------------------------------------    ▼         WARNINIG!!!        ▼     ------------------------------------------------------------------------|
# |------------------------------------------------    ▼  GENERATOR SERVICES BELOW  ▼     ------------------------------------------------------------------------|
# |------------------------------------------------    ▼         WARNINIG!!!        ▼     ------------------------------------------------------------------------|
# +---------------------------------------------------------------------------------------------------------------------------------------------------------------+

class GenerateDrawPlacesService
  def initialize(draw)
    @draw = draw
  end

  def call
    places = []

    @draw.tickets_count.times do |index|
      places << {
        draw_id: @draw.id,
        numbers: @draw.numbers,
        place_number: index + 1,
        is_sold: false,
        is_first_winner: false,
        is_second_winner: @draw.second_prize ? false : nil,
        client: nil
      }
    end
    redis = Redis.new
    redis.del("places:#{@draw.id}")
    redis.set("places:#{@draw.id}", places.to_json)
  end

  def create_winner_place
    redis = Redis.new
    places = JSON.parse(redis.get("places:#{@draw.id}"))

    first_place = rand(0..places.length - 1)
    second_place = rand(0..places.length - 1)

    while first_place == second_place
      second_place = rand(0..places.length - 1)
    end

    if @draw.second_prize
      places[first_place]['is_first_winner'] = true
      places[second_place]['is_second_winner'] = true
    end

    redis.del("places:#{@draw.id}")
    redis.set("places:#{@draw.id}", places.to_json)
  end 

  def cleanup 
    redis = Redis.new
    
    if @draw.expired_date <= Time.now
      @draw.update(is_active: false)
      
      places = JSON.parse(redis.get("places:#{@draw.id}"))

      first_winner = places.select { |ticket| ticket["is_first_winner"] == true }
      second_winner = places.select { |ticket| ticket["is_second_winner"] == true }
    
      Place.create(first_winner)
      Place.create(second_winner)
    end
  end
end

# +---------------------------------------------------------------------------------------------------------------------------------------------------------------+
# |------------------------------------------------    ▲         WARNINIG!!!        ▲     ------------------------------------------------------------------------|
# |------------------------------------------------    ▲  GENERATOR SERVICES ABOVE  ▲     ------------------------------------------------------------------------|
# |------------------------------------------------    ▲         WARNINIG!!!        ▲     ------------------------------------------------------------------------|
# +---------------------------------------------------------------------------------------------------------------------------------------------------------------+
