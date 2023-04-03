# == Schema Information
#
# Table name: taquillas
#
#  id         :bigint           not null, primary key
#  apikey     :string
#  name       :string
#  system     :string           default("Rifamax")
#  users_ids  :integer          default([]), is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :integer          not null
#
# Indexes
#
#  index_taquillas_on_owner_id   (owner_id)
#  index_taquillas_on_users_ids  (users_ids) USING gin
#
FactoryBot.define do
  factory :taquilla do
    name { "MyString" }
    apikey { "MyString" }
    user { nil }
  end
end
