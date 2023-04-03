# == Schema Information
#
# Table name: transactions
#
#  id                 :bigint           not null, primary key
#  amount             :float
#  reason             :string
#  reference          :string
#  transaction_type   :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  receiver_wallet_id :integer          not null
#  sender_wallet_id   :integer          not null
#
class Transaction < ApplicationRecord
  belongs_to :sender_wallet, class_name: "Wallet"
  belongs_to :receiver_wallet, class_name: "Wallet"
end
