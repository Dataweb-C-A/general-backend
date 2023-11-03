class AddIsClosedToDraws < ActiveRecord::Migration[7.0]
  def change
    add_column :draws, :is_closed, :boolean, default: false
  end
end
