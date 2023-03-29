class TaquillaSerializer < ActiveModel::Serializer
  attributes :id, :name, :apikey, :owner, :users

  def users
    object.users_ids.map do |rifero|
      UserSerializer.new(User.find(rifero)).as_json
    end
  end
end
