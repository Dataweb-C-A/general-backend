# == Schema Information
#
# Table name: exchanges
#
#  id         :bigint           not null, primary key
#  day        :date
#  money      :string
#  value      :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :exchange do
    money { "MyString" }
    value { 1.5 }
    day { "2023-05-16" }
  end
end
