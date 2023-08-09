# == Schema Information
#
# Table name: denominations
#
#  id         :bigint           not null, primary key
#  ammount    :float
#  category   :string
#  label      :string
#  money      :string
#  power      :float
#  quantity   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quadre_id  :bigint           not null
#
# Indexes
#
#  index_denominations_on_quadre_id  (quadre_id)
#
# Foreign Keys
#
#  fk_rails_...  (quadre_id => quadres.id)
#
FactoryBot.define do
  factory :denomination do
    money { "MyString" }
    quantity { "MyString" }
    quadre { nil }
  end
end