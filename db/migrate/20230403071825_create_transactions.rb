class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :reason
      t.string :transaction_type
      t.string :reference
      t.float :amount
      t.integer :sender_wallet_id, null: false
      t.integer :receiver_wallet_id, null: false

      t.timestamps
    end
  end
end
