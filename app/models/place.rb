# == Schema Information
#
# Table name: places
#
#  id            :bigint           not null, primary key
#  place_numbers :integer          default([]), is an Array
#  sold_at       :datetime         default(Wed, 14 Jun 2023 14:13:55.963926000 -04 -04:00)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
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

  def change_expired 
    @draw = Draw.find(self.draw_id)

    if @draw.draw_type == 'Progressive' 
      if Draw.progress(self.draw_id)[:current] >= @draw.limit
        @draw.update(expired_date: Date.today + 3)
      end
    end
  end 
end
