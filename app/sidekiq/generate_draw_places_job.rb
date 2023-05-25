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
      return draw
    end
  end

  def destroy(draw_id)
    Draw.find(draw_id).destroy
    redis.del("places:#{draw_id}")
  end

  def update(draw_id, *draw_params)
    Draw.find(draw_id).update(draw_params)
  end

  def sell_places(draw_id, place_position, client_data)
    @client
    redis = Redis.new
    
    if (Client.find_by(dni: client_data.dni))
      @client = Client.find_by(dni: client_data.dni)
    else
      @client = Client.create(client_data)
    end

    places = JSON.parse(redis.get("places:#{draw_id}"))

    places[place_position - 1]['is_sold'] = true
    places[place_position - 1]['client'] = @client

    redis.del("places:#{draw_id}")
    redis.set("places:#{draw_id}", places.to_json)
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
        is_winner: false,
        client: nil
      }
    end
    redis = Redis.new
    redis.set("places:#{@draw.id}", places.to_json)
  end
end

# +---------------------------------------------------------------------------------------------------------------------------------------------------------------+
# |------------------------------------------------    ▲         WARNINIG!!!        ▲     ------------------------------------------------------------------------|
# |------------------------------------------------    ▲  GENERATOR SERVICES ABOVE  ▲     ------------------------------------------------------------------------|
# |------------------------------------------------    ▲         WARNINIG!!!        ▲     ------------------------------------------------------------------------|
# +---------------------------------------------------------------------------------------------------------------------------------------------------------------+
