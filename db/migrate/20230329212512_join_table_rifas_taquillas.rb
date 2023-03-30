class JoinTableRifasTaquillas < ActiveRecord::Migration[7.0]
  def change
    create_join_table :rifas, :taquillas do |t|
      t.index :rifa_id
      t.index :taquilla_id
    end
  end
end
