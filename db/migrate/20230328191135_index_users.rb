class IndexUsers < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
    add_index :users, :cedula, unique: true
    add_index :users, :deleted_at
    add_index :users, :slug, unique: true
  end
end
