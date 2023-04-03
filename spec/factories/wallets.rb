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
