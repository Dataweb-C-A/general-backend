# == Schema Information
#
# Table name: rifas
#
#  id               :bigint           not null, primary key
#  awardNoSign      :string
#  awardSign        :string
#  expired          :date
#  is_send          :boolean
#  loteria          :string           not null
#  money            :string
#  numbers          :integer
#  pin              :string
#  plate            :string
#  price            :float
#  rifDate          :date
#  serial           :string
#  taquillas_ids    :integer          default([]), is an Array
#  tickets_are_sold :boolean          default(FALSE)
#  tickets_type     :string
#  verify           :boolean
#  year             :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_rifas_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
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
