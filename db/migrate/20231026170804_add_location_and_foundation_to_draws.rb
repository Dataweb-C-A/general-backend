class AddLocationAndFoundationToDraws < ActiveRecord::Migration[7.0]
  def change
    add_column :draws, :location, :string
    add_column :draws, :foundation, :string
  end
end
