class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.float :balance, default: 0.0
      t.float :debt, default: 0.0
      t.float :debt_limit, default: 0.0
      t.float :balance_limit, default: 10000.0
      t.string :api_key
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
