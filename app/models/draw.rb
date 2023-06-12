# == Schema Information
#
# Table name: draws
#
#  id                      :bigint           not null, primary key
#  ads                     :string
#  automatic_taquillas_ids :integer          default([]), is an Array
#  award                   :string           default([]), is an Array
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
#  owner_id                :integer          not null
#
class Draw < ApplicationRecord
  require 'image_uploader'

  mount_uploader :ads, ImageUploader
  mount_uploader :award, ImageUploader

  has_and_belongs_to_many :taquillas, class_name: 'Taquilla'
  has_many :places, dependent: :destroy

  after_create :generate_places
  after_commit :change_expired_date_by_draw_type, except: [:destroy]

  validates :title,
            presence: true,
            length: { minimum: 5, maximum: 50 }

  validates :first_prize,
            presence: true,
            length: { minimum: 5, maximum: 50 }
  
  # validates :second_prize,
  #           length: { minimum: 5, maximum: 50 }

  validates :init_date,
            presence: true,
            comparison: { greater_than_or_equal_to: Time.now.in_time_zone("Caracas").to_date() }
            
  validate :validate_expired_date

  validate :validate_draw_type
  
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

  # validates :limit,
  #           presence: false,
            # numericality: { only_integer: true, greater_than_or_equal_to: 1 }
          
  validates :price_unit,
            presence: true,
            numericality: { greater_than_or_equal_to: 0.1 }

  validates :money,
            presence: true,
            inclusion: { in: %w[BsF $ COP] }
      
  # validates :visible_taquillas_ids,
  #           presence: true
            
  # validates :automatic_taquillas_ids,
  #           presence: true

  validates :owner_id,
            presence: true

  # scope :active, -> { where('is_active = true') }
  # scope :expired, -> { where('is_active = false') }

  def generate_places
    GenerateDrawPlacesJob.new.generate(self.id)
  end

  def self.validate_draw_access(user_id, access_token)
    if (access_token == ENV['ACCESS_TOKEN'])
      if (Whitelist.find_by(user_id: user_id).present?)
        true
      else
        false 
      end
    else
      false
    end
  end

  def change_expired_date_by_draw_type
    redis = Redis.new

    if draw_type == "Progressive"
      tickets = JSON.parse(redis.get("places:#{self.id}"))

      sold_tickets_count = tickets.select { |ticket| ticket["is_sold"] == true }.count.to_f
      available_tickets_count = tickets.select { |ticket| ticket["is_sold"] == false }.count.to_f

      sold_average = ((sold_tickets_count / available_tickets_count) * 100).round(2)
    
      if sold_average >= self.limit
        expired_date = self.expired_date + 3.day
      else
        expired_date = nil
      end
    end
  end

  def validate_expired_date
    if expired_date.present? && init_date.present? && expired_date < init_date
      errors.add(:expired_date, "debe ser mayor que la fecha de inicio")
    end
  end

  def validate_draw_type
    if expired_date.present? && draw_type === "Progressive"
      errors.add(:draw_type, "No puede ser progresivo si tiene fecha de expiración")
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

  def self.progress(id)
    redis = Redis.new
    draw = Draw.find(id)

    if draw.draw_type != "To-Infinity"
      places = JSON.parse(redis.get("places:#{draw.id}"))
      
      solds = places.select { |ticket| ticket["is_sold"] == true }
      availables = places.select { |ticket| ticket["is_sold"] == false}
      current = (solds.count.to_f / (availables.count + solds.count).to_f) * 100

      progress = {
        available: availables.count,
        sold: solds.count,
        current: current
      }

      return progress
    else
      return {
        available: 0,
        sold: 0,
        current: 0
      }
    end
  end

  def self.get_winners(draw_id)
    redis = Redis.new
    tickets = JSON.parse(redis.get("places:#{draw_id}"))

    first_winner = tickets.select { |ticket| ticket["is_first_winner"] == true }
    second_winner = tickets.select { |ticket| ticket["is_second_winner"] == true }

    return { first_winner: first_winner, second_winner: second_winner }
  end

  # private

  # def broadcast_changes
  #   ActionCable.server.broadcast("draw_channel", draw: self)
  # end
end
