# == Schema Information
#
# Table name: whitelists
#
#  id         :bigint           not null, primary key
#  email      :string
#  name       :string
#  role       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
class Whitelist < ApplicationRecord
  has_one :whitelist
  
  def get_messages
    messages = []
    messages
  end
end
