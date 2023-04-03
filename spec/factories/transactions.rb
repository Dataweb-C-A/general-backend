# == Schema Information
#
# Table name: transactions
#
#  id                 :bigint           not null, primary key
#  amount             :float
#  reason             :string
#  reference          :string
#  status             :string
#  transaction_type   :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  receiver_wallet_id :integer          not null
#  sender_wallet_id   :integer          not null
#
FactoryBot.define do
  factory :transaction do
    reason { "MyString" }
    transaction_type { "MyString" }
    reference { "MyString" }
    amount { 1.5 }
    sender { nil }
    receiver { nil }
  end
end
