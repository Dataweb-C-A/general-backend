class TaquillaSerializer < ActiveModel::Serializer
  attributes :id, :name, :apikey, :owner, :created_at, :updated_at
end
