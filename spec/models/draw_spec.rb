# == Schema Information
#
# Table name: draws
#
#  id                      :bigint           not null, primary key
#  ads                     :string
#  automatic_taquillas_ids :integer          default([]), is an Array
#  award                   :string
#  draw_type               :string
#  expired_date            :date
#  first_prize             :string
#  first_winner            :integer
#  foundation              :string
#  has_winners             :boolean          default(FALSE)
#  init_date               :date
#  is_active               :boolean          default(TRUE)
#  limit                   :integer          default(100)
#  location                :string
#  loteria                 :string
#  money                   :string
#  numbers                 :integer
#  price_unit              :float
#  second_prize            :string
#  second_winner           :integer
#  ticket_setted           :integer          default(0)
#  tickets_count           :integer
#  title                   :string
#  type_of_draw            :string           default("")
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
