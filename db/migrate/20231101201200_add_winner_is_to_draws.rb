class AddWinnerIsToDraws < ActiveRecord::Migration[7.0]
  def change
    add_column :draws, :winner_is, :integer
  end
end
