# == Schema Information
#
# Table name: taquillas
#
#  id         :bigint           not null, primary key
#  apikey     :string
#  name       :string
#  system     :string           default("Rifamax")
#  users_ids  :integer          default([]), is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :integer          not null
#
# Indexes
#
#  index_taquillas_on_owner_id   (owner_id)
#  index_taquillas_on_users_ids  (users_ids) USING gin
#
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

  def self.show_riferos(owner)
    Taquilla.find_by(owner_id: owner).users_ids.each do |rifero|
      User.find(rifero)
    end
  end

  def as_json(options={})
    TaquillaSerializer.new(self).as_json
  end

  def self.search(query)
    where("name ILIKE ?", "%#{query}%")
  end
end
