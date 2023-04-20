class Ticket < ApplicationRecord
  belongs_to :rifa

  scope :sold, -> { where(is_sold: true) }
  scope :available, -> { where(is_sold: false) }

  scope :play, -> (play) { where(play: play) }

  validates :serial, presence: true
  validates :is_sold, inclusion: { in: [true, false] }

  def self.find_by_serial!(serial)
    find_by!(serial: serial)
  end

  def self.sold_out?(rifa_id)
    sold.where(rifa_id: rifa_id).count == rifa.tickets_count
  end

  def sell(tickets)
    if (tickets.classes == Array) 
      tickets.each do |ticket|
        if (ticket.is_sold == false)
          RifaTicket.find_by_serial!(ticket.serial).update!(is_sold: true)
        else
          raise ForbiddenException.new("Ticket already sold")
        end
      end
    end

    if (tickets.classes == Integer)
      RifaTicket.find_by_serial!(ticket.serial).update!(is_sold: true)
    end
    save!
  end

  def available?
    !is_sold?
  end
end
