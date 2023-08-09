class CreateQuadres < ActiveRecord::Migration[7.0]
  def change
    create_table :quadres do |t|
      t.date :day
      t.integer :total
      t.float :gastos
      t.integer :agency_id

      t.timestamps
    end
  end
end
