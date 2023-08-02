class AddCommissionPercentageToWhitelist < ActiveRecord::Migration[7.0]
  def change
    add_column :whitelists, :commission_percentage, :integer, :default => 15
  end
end
