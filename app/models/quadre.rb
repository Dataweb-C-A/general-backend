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
class Quadre < ApplicationRecord
  has_many :denomination
end
