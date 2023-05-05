# == Schema Information
#
# Table name: places
#
#  id         :bigint           not null, primary key
#  number     :integer
#  place_nro  :integer
#  sold_at    :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :bigint           not null
#  draw_id    :bigint           not null
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
require 'rails_helper'

RSpec.describe Place, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
