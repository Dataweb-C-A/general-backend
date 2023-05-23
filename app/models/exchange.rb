# == Schema Information
#
# Table name: exchanges
#
#  id         :bigint           not null, primary key
#  day        :date
#  money      :string
#  value      :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Exchange < ApplicationRecord
  include HTTParty
  base_uri 'https://s3.amazonaws.com/dolartoday/data.json'

  before_save :set_day

  private
  def validates_fields
    
  end

  def set_day
    self.day = Time.now.in_time_zone("Caracas").to_date()
  end
end
