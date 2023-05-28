# == Schema Information
#
# Table name: whitelists
#
#  id         :bigint           not null, primary key
#  email      :string
#  name       :string
#  role       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
FactoryBot.define do
  factory :whitelist do
    user_id { 1 }
    name { "MyString" }
    role { "MyString" }
    email { "MyString" }
  end
end
