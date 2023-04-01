class CreateRifaTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :rifa_tickets do |t|
      t.string :sign
      t.integer :number
      t.integer :ticket_nro
      t.string :serial
      t.boolean :is_sold

      t.timestamps
    end
  end
end
