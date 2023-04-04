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
class WalletSerializer < ActiveModel::Serializer
  attributes :id, :balance, :debt, :balance_limit, :debt_limit, :user, :transactions

  def user
    UserSerializer.new(object.user)
  end

  def transactions
    {
      senders: Transaction.find_by_sql("SELECT * FROM transactions WHERE sender_wallet_id = #{object.id} AND transaction_type = 'TRANSFER'"),
      receivers: Transaction.find_by_sql("SELECT * FROM transactions WHERE receiver_wallet_id = #{object.id} AND transaction_type = 'TRANSFER'"),
      deposits: Transaction.find_by_sql("SELECT * FROM transactions WHERE transaction_type = 'DEPOSIT' AND receiver_wallet_id = #{object.id} AND sender_wallet_id = #{object.id}"),
      withdraws: Transaction.find_by_sql("SELECT * FROM transactions WHERE transaction_type = 'WITHDRAW' AND sender_wallet_id = #{object.id} AND sender_wallet_id = #{object.id}")
    }
  end
end
