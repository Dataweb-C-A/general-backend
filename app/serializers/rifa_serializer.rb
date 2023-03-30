class RifaSerializer < ActiveModel::Serializer
  attributes  :id, 
              :price,
              :pin,
              :serial,
              :verify,
              :plate,
              :numbers,
              :year,
              :user, 
              :taquillas,
              :created_at,
              :updated_at

  def taquillas
    object.taquillas_ids.map do |taquilla|
      TaquillaSerializer.new(
        Taquilla.find(taquilla)
      )
    end
  end
end