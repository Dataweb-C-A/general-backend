class CreateRifas < ActiveRecord::Migration[7.0]
  def change
    create_table :rifas do |t|
      t.string :awardSign
      t.string :awardNoSign
      t.boolean :is_send
      t.date :rifDate
      t.date :expired
      t.string :money
      t.float :price
      t.string :pin
      t.string :serial
      t.boolean :verify
      t.string :plate
      t.integer :numbers
      t.integer :year
      t.integer :taquillas_ids, array: true, default: []
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
