class AddTicketSettedToDraws < ActiveRecord::Migration[7.0]
  def change
    add_column :draws, :ticket_setted, :integer, :default => 0
  end
end
