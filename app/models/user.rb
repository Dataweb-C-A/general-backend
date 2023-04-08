# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  avatar          :string
#  cedula          :string
#  deleted_at      :datetime
#  email           :string
#  name            :string
#  password_digest :string
#  phone           :string
#  role            :string
#  slug            :string
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_cedula      (cedula) UNIQUE
#  index_users_on_deleted_at  (deleted_at)
#  index_users_on_email       (email) UNIQUE
#  index_users_on_slug        (slug) UNIQUE
#  index_users_on_username    (username) UNIQUE
#
class User < ApplicationRecord
  acts_as_paranoid

  has_secure_password
  has_one_attached :avatar
  has_one :wallet
  has_one :taquilla

  has_many :owned_taquillas, class_name: 'Taquilla', foreign_key: 'owner_id'
  has_and_belongs_to_many :users, class_name: 'Taquilla', foreign_key: 'riferos_ids'

  default_scope { where(deleted_at: nil) }
  scope :active, -> { where(deleted_at: nil) }        

  validates :email, presence: true, uniqueness: true
  validates :cedula, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: %w(Admin Taquilla Rifero Auto) }
  validates :password,
            length: { minimum: 8 },
            if: -> { new_record? || !password.nil? }

  before_validation :generate_username, on: :create
  before_validation :generate_slug, on: :create
  before_create :generate_wallet
  
  before_save :process_avatar

  def generate_slug
    self.slug ||= "#{self.name.parameterize}-#{SecureRandom.hex(4)}"
  end

  def self.find_role(role)
    User.roles[role]
  end

  def generate_wallet 
    Wallet.create(balance: 0.0, debt: 0.0, debt_limit: 0.0, balance_limit: 10000.0, user_id: self.id)
  end

  def generate_username
    self.username ||= UsernameGeneratorService.generate_username
  end

  def avatar_url
    if avatar.attached?
      Rails.application.routes.url_helpers.rails_blob_url(avatar)
    else
      return nil
    end
  end

  def taquilla
    Taquilla.find_by(owner_id: self.id)
  end

  def as_json(options={})
    UserSerializer.new(self).as_json
  end

  def process_avatar
    return unless avatar.attached?

    # Resize the image to a maximum width of 300 pixels
    avatar.variant(resize_to_limit: [300, 300])

    # Compress the image to a maximum quality of 60%
    avatar.variant(quality: 60)

    # Convert the image to the JPEG format
    avatar.variant(convert: 'jpg')

    # Save the changes to the avatar image
    avatar.save
  end
  
  def restore
    update_attribute(:deleted_at, nil)
  end

  def settings
    Rails.cache.fetch([self, 'settings']) do
      # Retrieve the user-specific settings from the database
      user_settings = UserSettings.find_by(user_id: self.id)
  
      # If the user-specific settings do not exist, create them
      user_settings ||= UserSettings.create(user_id: self.id)
  
      # Return the user-specific settings
      user_settings
    end
  end

  def self.search(query)
    User.where("name LIKE ? OR username LIKE ? OR email LIKE ?", "%#{query}%", "%#{query}%", "%#{query}%")
  end

  def self.find_by_cedula!(cedula)
    User.find_by(cedula: cedula)
  end

  private

  def generate_unique_username
    return if username.blank?

    # Check if the username is already taken
    if User.exists?(username: username)
      # Generate a random string and append it to the username
      random_string = SecureRandom.hex(4)
      self.username = "#{username}_#{random_string}"
    end
  end
end
