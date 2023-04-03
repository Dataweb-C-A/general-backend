# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  avatar          :string
#  cedula          :string
#  deleted_at      :datetime
#  email           :string
#  name            :string
#  password_digest :string
#  phone           :string
#  role            :string
#  slug            :string
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_cedula      (cedula) UNIQUE
#  index_users_on_deleted_at  (deleted_at)
#  index_users_on_email       (email) UNIQUE
#  index_users_on_slug        (slug) UNIQUE
#  index_users_on_username    (username) UNIQUE
#
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
