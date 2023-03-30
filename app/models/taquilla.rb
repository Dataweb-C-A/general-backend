class Taquilla < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_and_belongs_to_many :users, class_name: 'User'
  has_many :rifas

  before_validation :generate_api_key, on: :create

  validates :name, presence: true
  # validates :system, default: 'Rifamax'
  validates :owner_id, presence: true

  def generate_api_key() 
    self.apikey = 'API-'+'D'+SecureRandom.hex(7)+'RM'+SecureRandom.hex(7)+'BG'+SecureRandom.hex(7)
  end

  def as_json(options={})
    TaquillaSerializer.new(self).as_json
  end

  def self.search(query)
    where("name ILIKE ?", "%#{query}%")
  end
end
