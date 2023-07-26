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
#  type_of_draw            :string           default("")
#  uniq                    :string
#  visible_taquillas_ids   :integer          default([]), is an Array
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  owner_id                :integer          not null
#
class DrawSerializer < ActiveModel::Serializer
  attributes  :id,
              :title,
              :first_prize,
              :second_prize,
              :adnoucement,
              :progress,
              :award_images,
              :uniq,
              :init_date,
              :expired_date,
              :numbers,
              :tickets_count,
              :loteria,
              :has_winners,
              :is_active,
              :tickets_count,
              :first_winner,
              :second_winner,
              :draw_type,
              :limit,
              :price_unit,
              :visible_taquillas_ids,
              :money,
              :owner,
              :created_at,
              :updated_at

  def adnoucement 
    @ad = object.ads
    if @ad != nil
      "https://#{ENV["HOST"]}#{@ad}"
    else
      nil
    end
  end

  def award_images
    @award = object.award
    if @award
      "https://#{ENV["HOST"]}#{@award}"
    else
      nil
    end
  end

  def progress 
    Draw.progress(object.id)
  end

  def owner
    Whitelist.find_by(user_id: object.owner_id)
  end
end
