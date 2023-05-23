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
require 'rails_helper'

RSpec.describe Exchange, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
