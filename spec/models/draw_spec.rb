# == Schema Information
#
# Table name: draws
#
#  id                      :bigint           not null, primary key
#  ads                     :string
#  automatic_taquillas_ids :integer          default([]), is an Array
#  award                   :string           default([]), is an Array
#  draw_type               :string
#  expired_date            :date
#  first_prize             :string
#  first_winner            :integer
#  has_winners             :boolean          default(FALSE)
#  init_date               :date
#  is_active               :boolean          default(TRUE)
#  limit                   :integer          default(100)
#  loteria                 :string
#  money                   :string
#  numbers                 :integer
#  price_unit              :float
#  second_prize            :string
#  second_winner           :integer
#  tickets_count           :integer
#  title                   :string
#  uniq                    :string
#  visible_taquillas_ids   :integer          default([]), is an Array
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  owner_id                :integer          not null
#
require 'rails_helper'

RSpec.describe Draw, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
