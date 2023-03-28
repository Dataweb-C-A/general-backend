class TaquillaSerializer < ActiveModel::Serializer
  attributes :id, :apikey, :owner, :riferos

  def riferos
    object.riferos_ids.map do |rifero|
      UserSerializer.new(User.find(rifero)).as_json
    end
  end
end
