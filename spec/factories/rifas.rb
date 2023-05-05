# == Schema Information
#
# Table name: rifas
#
#  id               :bigint           not null, primary key
#  awardNoSign      :string
#  awardSign        :string
#  expired          :date
#  is_send          :boolean
#  loteria          :string           not null
#  money            :string
#  numbers          :integer
#  pin              :string
#  plate            :string
#  price            :float
#  rifDate          :date
#  serial           :string
#  taquillas_ids    :integer          default([]), is an Array
#  tickets_are_sold :boolean          default(FALSE)
#  tickets_type     :string
#  verify           :boolean
#  year             :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_rifas_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :rifa do
    awardSign { "MyString" }
    awardNoSign { "MyString" }
    is_send { false }
    rifDate { "2023-03-29" }
    expired { "2023-03-29" }
    loteria { "MyString" }
    money { "MyString" }
    user { nil }
    price { 1.5 }
    pin { "MyString" }
    serial { "MyString" }
    verify { false }
    plate { "MyString" }
    numbers { 1 }
    year { 1 }
  end
end
