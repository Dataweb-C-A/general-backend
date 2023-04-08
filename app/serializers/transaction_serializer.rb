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
class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :reason, :transaction_type, :reference, :status, :sender_wallet, :receiver_wallet, :created_at, :updated_at
end
