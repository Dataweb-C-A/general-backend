class Rifa < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :taquillas, class_name: 'Taquilla'

  def as_json(options={})
    RifaSerializer.new(self).as_json
  end

  def add_taquilla(taquilla, rifa_id)
    Rifa.find(rifa_id).taquillas << Taquilla.find(taquilla)
  end
end
