# == Schema Information
#
# Table name: places
#
#  id            :bigint           not null, primary key
#  place_numbers :integer          default([]), is an Array
#  sold_at       :datetime         default(Sun, 16 Jul 2023 21:18:16.775265000 -04 -04:00)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  agency_id     :integer          not null
#  client_id     :bigint
#  draw_id       :bigint           not null
#
# Indexes
#
#  index_places_on_client_id  (client_id)
#  index_places_on_draw_id    (draw_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (draw_id => draws.id)
#
class Place < ApplicationRecord
  belongs_to :draw
  belongs_to :client

  before_commit :change_expired
  after_create :change_expired

  def self.validate_tickets(draw_id)
    redis = Redis.new
    places = redis.get("places:#{draw_id}")
    @draw = Draw.find(draw_id)

    if @draw.draw_type == 'Progressive' 
      if Draw.progress(draw_id)[:current] >= @draw.limit
        @draw.update(expired_date: Date.today + 3)
      end
    end

    if places.present?
      true
    else
      false
    end
  end

  def self.combo_price(place)
    case place.length
    when 1
      return 1
    when 6
      return 5
    when 15
      return 10
    else
      place.length
    end
  end

  def self.verify_redis_game(draw_id, places)
    redis = Redis.new

    if (redis.get("fifty:#{draw_id}") != nil)
      places_parsed = places.gsub(/\[|\]|\s/, '').split(',').map(&:to_i)
      existing_places_parsed = redis.get("fifty:#{draw_id}").gsub(/\[|\]|\s/, '').split(',').map(&:to_i)

      common_numbers = places_parsed & existing_places_parsed

      if common_numbers.length > 0
        return false
      else
        combined_array = (places_parsed + existing_places_parsed).sort
        redis.del("fifty:#{draw_id}")
        redis.set("fifty:#{draw_id}", combined_array.to_s)
        return true
      end
    else
      redis.set("fifty:#{draw_id}", places.to_s)
      return true
    end
  end

  def self.sold_at_by(fecha, agency)
    from = fecha.beginning_of_day
    to = fecha.end_of_day
    @agency_id = agency
    places = Place.where(sold_at: from..to, agency_id: @agency_id)
  
    return places
  end

  def self.earnings(agency_id, sold_at_date)
    places = []
    if sold_at_date 
      places = Place.sold_at_by(sold_at_date, agency_id)
    else
      places = Place.where(agency_id: agency_id)
    end
    total_earnings = 0
    places.each do |place|
      draw = place.draw

      next unless draw.price_unit.present?

      total_earnings += place.place_numbers.length * draw.price_unit
    end

    return total_earnings
  end

  def self.filter_earnings(agency_id, at, to)
    if at && to
      places = Place.where(sold_at: at..to, agency_id: agency_id)
    else
      places = Place.where(sold_at: at..to, agency_id: agency_id)
    end
    total_earnings = 0
    places.each do |place|
      draw = place.draw

      next unless draw.price_unit.present?

      total_earnings += place.place_numbers.length * draw.price_unit
    end

    return total_earnings
  end

  def self.admin_earnings(filter_date)
    places = Place.where(sold_at: filter_date)

    total_earnings = 0
    places.each do |place|
      draw = place.draw

      next unless draw.price_unit.present?

      total_earnings += place.place_numbers.length * draw.price_unit
    end

    return ("#{total_earnings.to_f.round(2).to_s}$")
  end

  def change_expired 
    @draw = Draw.find(self.draw_id)

    if @draw.draw_type == 'Progressive' 
      if Draw.progress(self.draw_id)[:current] >= @draw.limit
        @draw.update(expired_date: Date.today + 3)
      end
    end
  end 
end
