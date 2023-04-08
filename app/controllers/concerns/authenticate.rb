module Authenticate
  extend ActiveSupport::Concern

  included do
    before_action :authorize_request
  end

  def permit_access_to_admin!
    permit_access_by_role("Admin")
  end

  def permit_access_to_taquilla!
    permit_access_by_role("Taquilla")
  end

  def permit_access_to_riferos!
    permit_access_by_role("Riferos")
  end

  def permit_access_by_role(*roles)
    raise InsufficientPermissionsError unless roles.include?(@current_user.role)
  end
end

class InsufficientPermissionsError < StandardError
  def initialize(msg = "Insufficient permissions to handle action")
    super
  end
end
