# == Schema Information
#
# Table name: tickets
#
#  id           :bigint           not null, primary key
#  client_name  :string
#  client_phone :string
#  is_sold      :boolean          default(FALSE)
#  number       :integer
#  play         :string
#  serial       :string
#  sold_at      :datetime
#  ticket_nro   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  rifa_id      :bigint           not null
#
# Indexes
#
#  index_tickets_on_rifa_id  (rifa_id)
#
# Foreign Keys
#
#  fk_rails_...  (rifa_id => rifas.id)
#
require 'rails_helper'

RSpec.describe Ticket, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
