# == Schema Information
#
# Table name: wallets
#
#  id            :bigint           not null, primary key
#  api_key       :string
#  balance       :float            default(0.0)
#  balance_limit :float            default(10000.0)
#  debt          :float            default(0.0)
#  debt_limit    :float            default(0.0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_wallets_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :wallet do
    balance { 1.5 }
    debt { 1.5 }
    debt_limit { 1.5 }
    balance_limit { 1.5 }
    api_key { "MyString" }
    user { nil }
  end
end
