class CreateWhitelists < ActiveRecord::Migration[7.0]
  def change
    create_table :whitelists do |t|
      t.integer :user_id
      t.string :name
      t.string :role
      t.string :email

      t.timestamps
    end
  end
end
