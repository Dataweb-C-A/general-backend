# == Schema Information
#
# Table name: clients
#
#  id         :bigint           not null, primary key
#  dni        :string
#  email      :string
#  name       :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :client do
    name { "MyString" }
    phone { "MyString" }
    email { "MyString" }
    dni { "MyString" }
  end
end
