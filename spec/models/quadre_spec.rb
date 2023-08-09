# == Schema Information
#
# Table name: quadres
#
#  id         :bigint           not null, primary key
#  day        :date
#  gastos     :float
#  total      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  agency_id  :integer
#
require 'rails_helper'

RSpec.describe Quadre, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
