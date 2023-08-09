class CreateDenominations < ActiveRecord::Migration[7.0]
  def change
    create_table :denominations do |t|
      t.string :money
      t.float :power
      t.integer :quantity
      t.string :category
      t.string :label
      t.float :ammount
      t.references :quadre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
