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
class Wallet < ApplicationRecord
  belongs_to :user
  has_many :sent_transactions, class_name: "Transaction", foreign_key: "sender_wallet_id"
  has_many :received_transactions, class_name: "Transaction", foreign_key: "receiver_wallet_id"

  before_save :generate_api_key

  def generate_api_key
    self.api_key ||= SecureRandom.hex(32)
  end

  def send_money(amount, receiver_wallet)
    if self.balance >= amount
      transaction = Transaction.create(sender_wallet: self, receiver_wallet: receiver_wallet, amount: amount)
      self.update(balance: self.balance - amount)
      receiver_wallet.update(balance: receiver_wallet.balance + amount)
      return transaction
    else
      return nil
    end
  end

  def receive_money(amount, sender_wallet)
    transaction = Transaction.create(sender_wallet: sender_wallet, receiver_wallet: self, amount: amount)
    self.update(balance: self.balance + amount)
    sender_wallet.update(balance: sender_wallet.balance - amount)
    return transaction
  end
end
