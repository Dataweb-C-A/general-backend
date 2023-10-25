class AddCurrentIdToPrinterNotifications < ActiveRecord::Migration[7.0]
  def change
    add_column :printer_notifications, :current_id, :integer
  end
end
