class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.string :play
      t.integer :number
      t.integer :ticket_nro
      t.string :serial
      t.boolean :is_sold, default: false
      t.date :sold_at
      t.references :rifa, null: false, foreign_key: true

      t.timestamps
    end
  end
end
