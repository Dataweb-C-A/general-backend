# == Schema Information
#
# Table name: quadres
#
#  id         :bigint           not null, primary key
#  day        :date
#  gastos     :float
#  total      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  agency_id  :integer
#
FactoryBot.define do
  factory :quadre do
    money { "MyString" }
    day { "2023-08-07" }
    total { "MyString" }
    whitelist { nil }
  end
end
