class RifaTicket < ApplicationRecord
  belongs_to :rifa

  scope :sold, -> { where(is_sold: true) }
  scope :available, -> { where(is_sold: false) }

  validates :serial, presence: true
  validates :is_sold, inclusion: { in: [true, false] }

  before_save :generate_serial

  def generate_serial
    self.serial = SecureRandom.hex(5)
  end

  def self.find_by_serial!(serial)
    find_by!(serial: serial)
  end

  def self.sold_out?(rifa_id)
    sold.where(rifa_id: rifa_id).count == rifa.tickets_count
  end

  def sell!
    self.is_sold = true
    self.sold_at = Time.now.utc
    save!
  end

  def available?
    !is_sold?
  end
end
