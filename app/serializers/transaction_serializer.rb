class TransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :reason, :transaction_type, :reference, :status, :sender_wallet, :receiver_wallet, :created_at, :updated_at
end
