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
      redis = Redis.new
      redis.set("places:#{draw_id}:1", "[]")
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

  def sell_infinity(draw_id, place_positions, agency_id) 
    @draw = Draw.find(draw_id)

    return unless @draw

    draw = Draw.find(draw_id)
    draw.update(ticket_setted: ticket_setted+1)
    
    if check_tickets_status(draw_id, place_positions)
      return {
        error: "Los tickets ya están vendidos.",
        completed: false
      }
    else
      places_to_insert = []

      places_to_insert << {
        draw_id: draw_id,
        place_numbers: place_positions,
        agency_id: agency_id,
        sold_at: DateTime.now,
      }

      if places_to_insert.present?
        if Place.where(draw_id: @draw.id, place_numbers: place_positions).empty?
          Place.insert_all(places_to_insert)
          created_places = Place.where(draw_id: draw_id, place_numbers: place_positions)

          if Whitelist.find_by(user_id: agency_id).role == 'Auto'
            Inbox.create(
              message: "Monto: #{place_positions.length * @draw.price_unit}",
              request_type: "Auto",
              whitelist_id: Whitelist.where(name: Whitelist.find_by(user_id: agency_id).name).first.id
            )
          end

          return {
            error: nil,
            completed: true
          }
        end
      else
        return {
          error: "Los tickets ya están vendidos.",
          completed: false
        }
      end
    end
  end

  def sell_random(draw_id, numbers_of_places, agency_id)
    @draw = Draw.find(draw_id)
  
    return unless @draw

    #Draw.where(id: draw_id).update(ticket_setted: @draw.ticket_setted + 1)
  
    redis = Redis.new    

    # available_numbers = (1..10000).to_a - places_sold.map { |place| place['place_number'] }
    
    # if available_numbers.length >= numbers_of_places
    #   new_numbers = available_numbers.sample(numbers_of_places)
    # else
    #   max_place_number = places_sold.map { |place| place['place_number'] }.max || 10000
    #   expanded_range = (max_place_number + 1)..(max_place_number + 5000)
    #   new_numbers = expanded_range.to_a.sample(numbers_of_places)
    # end

    logger.debug(draw_id)
    logger.debug(numbers_of_places)
    logger.debug(agency_id)

    places = []

    if (redis.get("fifty:#{draw_id}") == nil)
      redis.set("fifty:#{draw_id}", "[]")
    end
    
    numbers_of_places.to_i.times do |index|
      places_unavailable = redis.get("fifty:#{draw_id}").gsub(/\[|\]|\s/, '').split(',').map(&:to_i)

      all_numbers_by_default = (1..10000).to_a

      random_result = 0

      available_numbers = []
      
      if (available_numbers.length == 0)
        sentinel = places_unavailable.length + 5000

        expanded_range = (places_unavailable.length + 1)..sentinel

        available_numbers = sentinel - places_unavailable

        random_result = available_numbers.to_a.sample(1)
      else
        available_numbers = all_numbers_by_default - places_unavailable

        random_result = available_numbers
      end

      places << {
        draw_id: @draw.id,
        place_numbers: rand(1..10000),
        sold_at: DateTime.now,
        agency_id: random_result,
        client_id: nil
      }
    end
    return {
      error: nil,
      completed: true,
      places: places
    }
  end
  

  def sell_places(draw_id, place_positions, agency_id)
    redis = Redis.new
    @draw = Draw.find(draw_id)
  
    draw = Draw.find(draw_id)
    draw.update(ticket_setted: draw.ticket_setted+1)
  
    return unless @draw
  
    if @draw.is_active == false
      puts '¡Sorteo vencido!'
      return {
        error: "¡Sorteo vencido!",
        completed: false
      }
    else
      places = JSON.parse(redis.get("places:#{draw_id}"))

      sold_positions = []
  
      place_positions.each do |position|
        if position > places.length || position < 1
          puts "El lugar #{position} no existe."
          next
        end
  
        place = places[position - 1]
  
        if place['is_sold']
          puts "El lugar #{position} ya está vendido."
          sold_positions << position # Add the sold position to the list
          next
        end
  
        place['is_sold'] = true
        # place['client'] = client_data
  
        puts "Lugar #{position} vendido correctamente."
      end
  
      if sold_positions.any?
        return {
          error: "Los tickets ya están vendidos en las posiciones #{sold_positions}.",
          completed: false
        }
      end
  
      places_to_insert = []

      places_to_insert << {
        draw_id: draw_id,
        place_numbers: place_positions,
        agency_id: agency_id,
        sold_at: DateTime.now,
      }
  
      if places_to_insert.present?
        if Place.where(draw_id: @draw.id, place_numbers: place_positions).empty?
          Place.insert_all(places_to_insert)
          # Declare a variable to get the created Place
          created_places = Place.where(draw_id: draw_id, place_numbers: place_positions)
  
          if Whitelist.find_by(user_id: agency_id).role == 'Auto'
            Inbox.create(
              message: "Monto: #{place_positions.length * @draw.price_unit} \n Numeros: #{place_positions} \n Premio: #{@draw.first_prize} \n Tipo: #{@draw.type_of_draw} \n Agencia: #{Whitelist.find_by(user_id: agency_id).name} \n Tipo sorteo: #{@draw.draw_type} \n Fecha limite: #{@draw.expired_date == nil ? 'Por anunciar' : @draw.expired_date}",
              request_type: "Auto",
              whitelist_id: Whitelist.where(name: Whitelist.find_by(user_id: agency_id).name).first.id
            )
          end
  
          redis.del("places:#{draw_id}")
          redis.set("places:#{draw_id}", places.to_json)
  
          return {
            error: nil,
            completed: true
          }
        end
      else
        return {
          error: "Los tickets ya están vendidos.",
          completed: false
        }
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

    @draw.update(ticket_setted: draw.ticket_setted+1)
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
