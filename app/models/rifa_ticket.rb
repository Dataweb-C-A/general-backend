class RifaTicket < ApplicationRecord
  belongs_to :rifa

  scope :sold, -> { where(is_sold: true) }
  scope :available, -> { where(is_sold: false) }

  def self.find_by_serial!(serial)
    return RifaTicket.find_by_serial(serial)
  end
end
