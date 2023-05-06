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
