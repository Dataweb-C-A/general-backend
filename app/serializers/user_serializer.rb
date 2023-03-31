class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  
  attributes  :id, 
              :name, 
              :username, 
              :email, 
              :avatar_url, 
              :cedula, 
              :role, 
              :created_at, 
              :updated_at
  
  def avatar_url
    if object.avatar.attached?
      url_for(object.avatar)
    else
      nil
    end
  end
end