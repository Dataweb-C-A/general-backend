# == Schema Information
#
# Table name: rifa_tickets
#
#  id         :bigint           not null, primary key
#  is_sold    :boolean
#  number     :integer
#  serial     :string
#  sign       :string
#  sold_at    :string
#  ticket_nro :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  rifa_id    :bigint           not null
#
# Indexes
#
#  index_rifa_tickets_on_rifa_id  (rifa_id)
#
# Foreign Keys
#
#  fk_rails_...  (rifa_id => rifas.id)
#
require 'rails_helper'

RSpec.describe RifaTicket, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
