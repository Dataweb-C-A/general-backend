# == Schema Information
#
# Table name: exchanges
#
#  id            :bigint           not null, primary key
#  automatic     :boolean          default(FALSE)
#  variacion_bs  :float
#  variacion_cop :float            not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :exchange do
    money { "MyString" }
    value { 1.5 }
    day { "2023-05-16" }
  end
end
