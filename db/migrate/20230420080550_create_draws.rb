class CreateDraws < ActiveRecord::Migration[7.0]
  def change
    create_table :draws do |t|
      t.string :award, array: true, default: []
      t.string :ads
      t.string :title
      t.string :first_prize
      t.string :second_prize
      t.string :uniq
      t.string :type_of_draw, default: ''
      t.date :init_date
      t.date :expired_date
      t.integer :numbers
      t.integer :tickets_count
      t.string :loteria
      t.boolean :has_winners, default: false
      t.boolean :is_active, default: true
      t.integer :first_winner
      t.integer :second_winner
      t.integer :owner_id, null: false
      t.string :draw_type
      t.integer :limit, min: 1, max: 100, default: 100
      t.float :price_unit
      t.string :money
      t.integer :visible_taquillas_ids, array: true, default: []
      t.integer :automatic_taquillas_ids, array: true, default: []

      t.timestamps
    end
  end
end
