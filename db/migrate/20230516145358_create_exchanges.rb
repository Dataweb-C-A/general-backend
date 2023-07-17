class CreateExchanges < ActiveRecord::Migration[7.0]
  def change
    create_table :exchanges do |t|
      t.float :variacion_bs, null: true
      t.float :variacion_cop, null: true
      t.boolean :automatic, default: false

      t.timestamps
    end
  end
end
