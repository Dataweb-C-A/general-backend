# == Schema Information
#
# Table name: draws
#
#  id                      :bigint           not null, primary key
#  automatic_taquillas_ids :integer          default([]), is an Array
#  draw_type               :string
#  expired_date            :date
#  first_prize             :string
#  first_winner            :integer
#  has_winners             :boolean          default(FALSE)
#  init_date               :date
#  is_active               :boolean          default(TRUE)
#  limit                   :integer          default(100)
#  loteria                 :string
#  money                   :string
#  numbers                 :integer
#  price_unit              :float
#  second_prize            :string
#  second_winner           :integer
#  tickets_count           :integer
#  title                   :string
#  uniq                    :string
#  visible_taquillas_ids   :integer          default([]), is an Array
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
class Draw < ApplicationRecord
  has_and_belongs_to_many :taquillas, class_name: 'Taquilla'
  has_many :places, dependent: :destroy

  after_create :generate_places

  def generate_places
    GenerateDrawPlacesJob.new.generate(self.id)
  end
end
