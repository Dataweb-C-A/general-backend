# == Schema Information
#
# Table name: transactions
#
#  id                 :bigint           not null, primary key
#  amount             :float
#  reason             :string
#  reference          :string
#  status             :string
#  transaction_type   :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  receiver_wallet_id :integer          not null
#  sender_wallet_id   :integer          not null
#
class Transaction < ApplicationRecord
  belongs_to :sender_wallet, class_name: "Wallet"
  belongs_to :receiver_wallet, class_name: "Wallet"

  scope :pending, -> { where(status: "pending") }
  scope :completed, -> { where(status: "completed") }
  scope :denied, -> { where(status: "denied") }
  scope :cancelled, -> { where(status: "cancelled") }

  scope :deposit, -> { where(transaction_type: "deposit") }
  scope :withdraw, -> { where(transaction_type: "withdraw") }
  scope :transfer, -> { where(transaction_type: "transfer") }

  scope :created_within, ->(start_date, end_date) { where(created_at: start_date..end_date) }

  include AASM

  validates :amount, presence: true
  validates :transaction_type, presence: true
  validates :sender_wallet_id, presence: true
  validates :receiver_wallet_id, presence: true

  before_save :generate_reference

  aasm do
    state :pending, initial: true
    state :cancelled
    state :denied
    state :completed

    event :cancel do 
      transitions from [:pending], to: :cancelled
    end

    event :deny do
      transitions from [:pending], to: :denied
    end

    event :complete do
      transitions from [:pending], to: :completed
    end
  end

  def generate_reference
    self.reference ||= parse_id_from_reference()
  end

  def parse_id_from_reference
    id_width = 4
    id_format = "%0#{id_width}d"
    return "#{id_format % self.id}-#{SecureRandom.hex(4)}"
  end

  def self.find_by_reference(reference)
    find_by(reference: reference)
  end
end
