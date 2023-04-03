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
FactoryBot.define do
  factory :rifa_ticket do
    sign { "MyString" }
    number { 1 }
    ticket_nro { 1 }
    serial { "MyString" }
    is_sold { false }
  end
end
