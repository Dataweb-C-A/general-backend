class CreateExchanges < ActiveRecord::Migration[7.0]
  def change
    create_table :exchanges do |t|
      t.string :money
      t.float :value
      t.date :day

      t.timestamps
    end
  end
end
