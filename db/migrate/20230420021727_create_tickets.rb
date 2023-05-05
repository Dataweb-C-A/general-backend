class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.string :play
      t.integer :number
      t.integer :ticket_nro
      t.string :serial
      t.boolean :is_sold, default: false
      t.string :client_name
      t.string :client_phone
      t.datetime :sold_at

      t.references :rifa, null: false, foreign_key: true

      t.timestamps
    end
  end
end
