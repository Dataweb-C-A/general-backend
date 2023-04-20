# == Schema Information
#
# Table name: tickets
#
#  id         :bigint           not null, primary key
#  is_sold    :boolean          default(FALSE)
#  number     :integer
#  play       :string
#  serial     :string
#  sold_at    :date
#  ticket_nro :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  rifa_id    :bigint           not null
#
# Indexes
#
#  index_tickets_on_rifa_id  (rifa_id)
#
# Foreign Keys
#
#  fk_rails_...  (rifa_id => rifas.id)
#
FactoryBot.define do
  factory :ticket do
    play { "MyString" }
    number { 1 }
    ticket_nro { 1 }
    serial { "MyString" }
    is_sold { false }
    sold_at { false }
  end
end
