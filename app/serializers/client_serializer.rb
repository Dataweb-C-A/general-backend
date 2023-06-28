# == Schema Information
#
# Table name: clients
#
#  id         :bigint           not null, primary key
#  dni        :string
#  email      :string
#  name       :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ClientSerializer < ActiveModel::Serializer
  attributes :id, 
             :name, 
             :phone, 
             :dni

  def places
    object.place_ids.map do |place|
      Place.find(place).place_numbers
    end
  end
end
