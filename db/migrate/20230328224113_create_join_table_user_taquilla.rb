class CreateJoinTableUserTaquilla < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :taquillas do |t|
      t.index :user_id
      t.index :taquilla_id
    end
  end
end
