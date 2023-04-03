# == Schema Information
#
# Table name: taquillas
#
#  id         :bigint           not null, primary key
#  apikey     :string
#  name       :string
#  system     :string           default("Rifamax")
#  users_ids  :integer          default([]), is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :integer          not null
#
# Indexes
#
#  index_taquillas_on_owner_id   (owner_id)
#  index_taquillas_on_users_ids  (users_ids) USING gin
#
require 'rails_helper'

RSpec.describe Taquilla, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
