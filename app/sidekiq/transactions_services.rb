class TransactionServices < ApplicationJob
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform_async(wallet_id, transaction_id)
    wallet = Wallet.find(wallet_id)
    transaction = Transaction.find(transaction_id)

    ActiveRecord::Base.transaction do
      TransactionOptions.new(wallet, transaction).transaction
    end
  end
end

# +---------------------------------------------------------------------------------------------------------------------------------------------------------------+
# |------------------------------------------------    ▼         WARNINIG!!!        ▼     ------------------------------------------------------------------------|
# |------------------------------------------------    ▼  GENERATOR SERVICES BELOW  ▼     ------------------------------------------------------------------------|
# |------------------------------------------------    ▼         WARNINIG!!!        ▼     ------------------------------------------------------------------------|
# +---------------------------------------------------------------------------------------------------------------------------------------------------------------+

class TransactionOptions
  include Sidekiq::Worker
  sidekiq_options retry: false

  def initialize(wallet, transaction)
    @wallet = wallet
    @transaction = transaction
    @sender_wallet = Wallet.find(@transaction.sender_wallet_id)
    @receiver_wallet = Wallet.find(@transaction.receiver_wallet_id)
  end

  def transaction
    case @transaction.transaction_type
    when "DEPOSIT"
    
    when "WITHDRAW"
    
    when "TRANSFER"
    
    else
      raise "Invalid transaction type"
    end
  end
end

# +---------------------------------------------------------------------------------------------------------------------------------------------------------------+
# |------------------------------------------------    ▲         WARNINIG!!!        ▲     ------------------------------------------------------------------------|
# |------------------------------------------------    ▲  GENERATOR SERVICES ABOVE  ▲     ------------------------------------------------------------------------|
# |------------------------------------------------    ▲         WARNINIG!!!        ▲     ------------------------------------------------------------------------|
# +---------------------------------------------------------------------------------------------------------------------------------------------------------------+