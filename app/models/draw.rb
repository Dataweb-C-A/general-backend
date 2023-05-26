# == Schema Information
#
# Table name: draws
#
#  id                      :bigint           not null, primary key
#  automatic_taquillas_ids :integer          default([]), is an Array
#  award                   :string
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
  has_many_attached :award

  has_and_belongs_to_many :taquillas, class_name: 'Taquilla'
  has_many :places, dependent: :destroy

  after_create :generate_places
  after_commit :broadcast_changes, on: [:create, :update]

  validates :title,
            presence: true,
            length: { minimum: 5, maximum: 50 }

  validates :first_prize,
            presence: true,
            length: { minimum: 5, maximum: 50 }
  
  validates :second_prize,
            length: { minimum: 5, maximum: 50 }

  validates :init_date,
            presence: true,
            comparison: { greater_than_or_equal_to: Time.now.in_time_zone("Caracas").to_date() }
            
  validate :validate_expired_date
  
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
            inclusion: { in: %w[Progressive End-To-Date To-Infinity] }

  validates :limit,
            presence: false,
            numericality: { only_integer: true, greater_than_or_equal_to: 1 }
          
  validates :price_unit,
            presence: true,
            numericality: { greater_than_or_equal_to: 0.1 }

  validates :money,
            presence: true,
            inclusion: { in: %w[BsF $ COP] }
      
  validates :visible_taquillas_ids,
            presence: true
            
  validates :automatic_taquillas_ids,
            presence: true

  validates :owner_id,
            presence: true

  # scope :active, -> { where('is_active = true') }
  # scope :expired, -> { where('is_active = false') }

  def generate_places
    GenerateDrawPlacesJob.new.generate(self.id)
  end

  def validate_expired_date
    if expired_date.present? && init_date.present? && expired_date < init_date
      errors.add(:expired_date, "debe ser mayor que la fecha de inicio")
    end
  end

  def award_url
    if award.attached?
      Rails.application.routes.url_helpers.rails_blob_url(award)
    else
      return nil
    end
  end

  def self.find_awards_by_owner(id)
    Draw.where(owner_id: id)
  end

  private

  def broadcast_changes
    ActionCable.server.broadcast("draw_channel", draw: self)
  end
end
