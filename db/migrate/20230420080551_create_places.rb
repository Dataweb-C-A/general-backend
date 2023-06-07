class CreatePlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :places do |t|
      t.integer :numbers
      t.integer :place_number
      t.date :sold_at, default: Time.now
      t.references :client, null: true, foreign_key: true
      t.references :draw, null: false, foreign_key: true

      t.timestamps
    end
  end
end
