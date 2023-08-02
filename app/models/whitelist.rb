# == Schema Information
#
# Table name: whitelists
#
#  id                    :bigint           not null, primary key
#  commission_percentage :integer          default(15)
#  email                 :string
#  name                  :string
#  role                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id               :integer
#
class Whitelist < ApplicationRecord
  has_one :whitelist
  
  def get_messages
    messages = []
    messages
  end

  def self.user_ids
    agencies_ids = []
    Whitelist.all.each do |agency|
      agencies_ids << agency.user_id
    end
    return agencies_ids
  end
end
