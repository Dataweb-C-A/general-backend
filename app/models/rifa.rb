class Rifa < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :taquillas, class_name: 'Taquilla'
  has_many :rifa_tickets, dependent: :destroy

  scope :expired, -> { where('NOW() >= expired') }
  scope :active, -> { where('NOW() < expired') }

  validates :rifDate, presence: true
  validates :awardSign, presence: true
  validates :money, presence: true
  validates :price, presence: true
  validates :numbers, presence: true
  validates :expired, comparison: { greater_than: :rifDate }

  before_save :generate_serial
  before_save :add_expired

  def as_json(options={})
    RifaSerializer.new(self).as_json
  end

  def self.find_by_user(user)
    Rifa.where(user_id: user)
  end

  def self.find_by_taquillas(taquillas_ids)
    if (taquillas_ids.class == Integer) 
      return Rifa.where(taquillas_ids: [taquillas_ids])
    end

    if (taquillas_ids.class != Array)
      return { 
        error: 'Not an Array of numbers or Number, try again...',
        message: 'Not an array',
        status_code: 400
      }
    end
    if (taquillas_ids.empty?)
      return {
        error: 'Not taquillas found',
        status_code: 404,
        redirect: 'https://admin.rifa-max.com/login'
      }
    end

    Rifa.where(taquillas_ids: taquillas_ids) === [] ? {
      error: 'Not taquillas found',
      message: 'Not taquillas found',
      status_code: 404,
    } : Rifa.where(taquillas_ids: taquillas_ids)
  end

  def self.search(query)
    where("serial ILIKE ?", "%#{query}%")
  end

  def generate_serial
    self.serial = SecureRandom.hex(5)
  end

  def add_taquilla(taquilla, rifa_id)
    Rifa.find(rifa_id).taquillas << Taquilla.find(taquilla)
  end

  def add_expired
    self.expired = self.rifDate + 5.days
  end
end
