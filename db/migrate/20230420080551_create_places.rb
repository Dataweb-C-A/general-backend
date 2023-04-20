class CreatePlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :places do |t|
      t.string :sold_client_name
      t.string :sold_client_phone
      t.string :sold_client_email
      t.string :sold_client_dni
      t.integer :number
      t.integer :place_nro
      t.date :sold_at
      t.references :draw, null: false, foreign_key: true

      t.timestamps
    end
  end
end
