# == Schema Information
#
# Table name: draws
#
#  id                      :bigint           not null, primary key
#  automatic_taquillas_ids :integer          default([]), is an Array
#  award                   :string
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
class DrawSerializer < ActiveModel::Serializer
  attributes  :id,
              :title,
              :awards_url,
              :first_prize,
              :second_prize,
              :uniq,
              :init_date,
              :expired_date,
              :numbers,
              :tickets_count,
              :loteria,
              :has_winners,
              :is_active,
              :first_winner,
              :second_winner,
              :draw_type,
              :limit,
              :price_unit,
              :money,
              :owner,
              :created_at,
              :updated_at

  def awards_url
    object.award.map do |award|
      Rails.application.routes.url_helpers.rails_blob_url(award)
    end
  end

  def owner
    Whitelist.find_by(user_id: object.owner_id)
  end
end
