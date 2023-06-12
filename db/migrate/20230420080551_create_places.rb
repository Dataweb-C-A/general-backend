class CreatePlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :places do |t|
      t.integer :place_numbers, array: true, default: []
      t.datetime :sold_at, default: DateTime.now
      t.references :client, null: true, foreign_key: true
      t.references :draw, null: false, foreign_key: true

      t.timestamps
    end
  end
end
