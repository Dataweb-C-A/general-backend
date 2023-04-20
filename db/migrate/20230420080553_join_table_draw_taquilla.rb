class JoinTableDrawTaquilla < ActiveRecord::Migration[7.0]
  def change
    create_join_table :draws, :taquillas do |t|
      t.index :draw_id
      t.index :taquilla_id
    end
  end
end
