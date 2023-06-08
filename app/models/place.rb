# == Schema Information
#
# Table name: places
#
#  id           :bigint           not null, primary key
#  numbers      :integer
#  place_number :integer
#  sold_at      :date             default(Thu, 08 Jun 2023)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  client_id    :bigint
#  draw_id      :bigint           not null
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

  def self.validate_tickets(draw_id)
    redis = Redis.new
    places = redis.get("places:#{draw_id}")

    if places.present?
      true
    else
      false
    end
  end
end
