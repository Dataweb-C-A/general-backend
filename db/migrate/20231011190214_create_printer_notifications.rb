class CreatePrinterNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :printer_notifications do |t|
      t.integer :tickets_generated, array: true, default: []
      t.integer :user_id, null: false
      t.boolean :is_printed, default: false

      t.timestamps
    end
  end
end
