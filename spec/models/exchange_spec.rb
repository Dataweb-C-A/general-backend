# == Schema Information
#
# Table name: exchanges
#
#  id            :bigint           not null, primary key
#  automatic     :boolean          default(FALSE)
#  variacion_bs  :float
#  variacion_cop :float            not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe Exchange, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
