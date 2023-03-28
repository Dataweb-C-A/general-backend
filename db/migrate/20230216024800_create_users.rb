class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :avatar
      t.string :name
      t.string :username
      t.string :cedula
      t.string :email
      t.string :password_digest
      t.datetime :deleted_at # Add a column to store whether the record is deleted or not
      t.string :slug # Add a column to store the slug

      t.timestamps
    end
  end
end
