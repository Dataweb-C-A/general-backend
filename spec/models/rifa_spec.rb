# == Schema Information
#
# Table name: rifas
#
#  id            :bigint           not null, primary key
#  awardNoSign   :string
#  awardSign     :string
#  expired       :date
#  is_send       :boolean
#  loteria       :string           not null
#  money         :string
#  numbers       :integer
#  pin           :string
#  plate         :string
#  price         :float
#  rifDate       :date
#  serial        :string
#  taquillas_ids :integer          default([]), is an Array
#  tickets_type  :string
#  verify        :boolean
#  year          :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_rifas_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Rifa, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
