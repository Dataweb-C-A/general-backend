# == Schema Information
#
# Table name: places
#
#  id            :bigint           not null, primary key
#  place_numbers :integer          default([]), is an Array
#  sold_at       :datetime         default(Tue, 27 Jun 2023 16:58:38.471230000 -04 -04:00)
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
FactoryBot.define do
  factory :place do
    
  end
end
