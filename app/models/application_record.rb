class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  scope :created_within, ->(start_date, end_date) { where(created_at: start_date..end_date) }

  def self.api_key_generator
    return "API-RM#{SecureRandom.hex(32)}"
  end
end
