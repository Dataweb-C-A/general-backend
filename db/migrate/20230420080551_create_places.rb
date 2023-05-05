class CreatePlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :places do |t|
      t.integer :number
      t.integer :place_nro
      t.date :sold_at
      t.references :client, null: false, foreign_key: true
      t.references :draw, null: false, foreign_key: true

      t.timestamps
    end
  end
end
