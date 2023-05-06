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

  validates :title,
            presence: true,
            length: { minimum: 5, maximum: 50 }

  validates :first_prize,
            presence: true,
            length: { minimum: 5, maximum: 50 }
  
  validates :second_prize,
            length: { minimum: 5, maximum: 50 }

  validates :init_date,
            presence: true
            greater_than_or_equal_to: Date.today
  
  validates :expired_date,
            greater_than_or_equal_to: :init_date

  validates :numbers,
            presence: true,
            numericality: { 
                            only_integer: true, 
                            greater_than_or_equal_to: 1, 
                            less_than_or_equal_to: 999 
                          }

  validates :tickets_count,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 100 }

  validates :loteria,
            presence: true,
            length: { minimum: 5, maximum: 50 }
          
  validates :draw_type,
            presence: true,
            inclusion: { in: %w[Progressive End-To-Date] }

  validates :limit,
            presence: false,
            numericality: { only_integer: true, greater_than_or_equal_to: 1 }
          
  validates :price_unit,
            presence: true,
            numericality: { greater_than_or_equal_to: 0.1 }

  validates :money,
            presence: true,
            inclusion: { in: %w[BsF $ COL] }
      
  validates :visible_taquillas_ids,
            presence: true,
            
  validates :automatic_taquillas_ids,
            presence: true,

  scope :active, -> { where('is_active = true') }
  scope :expired, -> { where('is_active = false') }

  def generate_places
    GenerateDrawPlacesJob.new.generate(self.id)
  end

  def self.stats(current)
    return unless current 
    
    roles = {
      'Admin': -> { Draw.all.count }
    }
  end
end
