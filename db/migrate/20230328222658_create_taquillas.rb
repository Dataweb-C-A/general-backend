class CreateTaquillas < ActiveRecord::Migration[7.0]
  def change
    create_table :taquillas do |t|
      t.string :name
      t.string :apikey
      t.integer :owner_id, null: false
      t.integer :users_ids, array: true, default: []

      t.timestamps
    end
  end
end
