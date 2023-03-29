class IndexTaquillas < ActiveRecord::Migration[7.0]
  def change
    add_index :taquillas, :owner_id
    add_index :taquillas, :users_ids, using: 'gin'
  end
end
