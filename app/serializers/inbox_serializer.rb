class InboxSerializer < ActiveModel::Serializer
  attributes :id,
             :message,
             :request_type,
             :agency

  def agency
    Whitelist.find_by(user_id: object.whitelist_id)
  end
end
