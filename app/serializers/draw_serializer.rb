class DrawSerializer < ActiveModel::Serializer
  attributes :id,
              :title,
              :award_url,
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
              :visible_taquillas_ids,
              :automatic_taquillas_ids,
              :created_at,
              :updated_at

  def award_url
    if object.award.attached?
      Rails.application.routes.url_helpers.rails_blob_url(object.award)
    else
      nil
    end
  end
end
