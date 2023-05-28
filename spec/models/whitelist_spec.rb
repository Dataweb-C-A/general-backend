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
require 'rails_helper'

RSpec.describe Whitelist, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
