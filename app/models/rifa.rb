# == Schema Information
#
# Table name: rifas
#
#  id            :bigint           not null, primary key
#  awardNoSign   :string
#  awardSign     :string
#  expired       :date
#  is_send       :boolean
#  loteria       :string           not null
#  money         :string
#  numbers       :integer
#  pin           :string
#  plate         :string
#  price         :float
#  rifDate       :date
#  serial        :string
#  taquillas_ids :integer          default([]), is an Array
#  tickets_type  :string
#  verify        :boolean
#  year          :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_rifas_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Rifa < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :taquillas, class_name: 'Taquilla'
  has_many :tickets, dependent: :destroy

  scope :expired, -> { where('NOW() >= expired') }
  scope :active, -> { where('NOW() < expired') }

  validates :rifDate, presence: true, comparison: { greater_than_or_equal_to: Date.today }
  validates :awardSign, presence: true
  validates :money, presence: true
  validates :price, presence: true
  validates :numbers, presence: true
  # validates :taquillas_ids, presence: true, array: true, length: { minimum: 1 }

  before_save :generate_serial
  before_save :add_expired
  after_create :generate_tickets

  def as_json(options={})
    RifaSerializer.new(self).as_json
  end

  def self.sold_tickets(tickets_ids)
    if (tickets_ids.class == Integer)
      return Ticket.find(tickets_ids).update(is_sold: true, sold_at: Time.now)
    end

    if (tickets_ids.class == Array)
      return Ticket
    end

    return {
      error: 'Not an Array of numbers or Number',
      message: 'Not an array',
      status_code: 400
    }
  end

  def generate_tickets
    GenerateRifaTicketsJob.new.generate(self.id)
  end

  def self.filter_actives(user_id, type = 'All')
    case type
    when 'Signs'
      return Rifa.where(user_id: user_id, expired: Date.today..Date.today + 5.days, tickets_type: 'Signs')
    when 'Wildcards'
      return Rifa.where(user_id: user_id, expired: Date.today..Date.today + 5.days, tickets_type: 'Wildcards')
    else
      return Rifa.where(user_id: user_id, expired: Date.today..Date.today + 5.days)
    end
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
        redirect: 'https://admin.rifa-max.com/'
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
