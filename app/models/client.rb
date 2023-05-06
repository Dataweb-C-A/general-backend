# == Schema Information
#
# Table name: clients
#
#  id         :bigint           not null, primary key
#  dni        :string
#  email      :string
#  name       :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Client < ApplicationRecord
  has_many :places, dependent: :destroy

  validates :dni, 
            presence: true, 
            uniqueness: true, 
            length: { minimum: 6, maximum: 10 }, 
            inclusion: { in: %w(V E) }

  validates :name, 
            presence: true, 
            length: { minimum: 3, maximum: 50 }

  validates :phone, 
            presence: true, 
            length: { minimum: 11, maximum: 11 }, 
            numericality: { only_integer: true }, 
            uniqueness: true, 
            format: { with: /\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/ }

  validates :email, 
            presence: true, 
            uniqueness: true, 
            length: { minimum: 5, maximum: 50 }, 
            format: { with: URI::MailTo::EMAIL_REGEXP }
end
