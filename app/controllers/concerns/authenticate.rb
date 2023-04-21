module Authenticate
  extend ActiveSupport::Concern

  included do
    before_action :authorize_request
  end

  def authorize_admin
    return false unless @current_user.Admin?

    true
  end

  def authorize_taquilla
    return false unless @current_user.Taquilla?

    true
  end

  def authorize_rifero
    return false unless @current_user.Rifero? 

    true
  end
end

class InsufficientPermissionsError < StandardError
  def initialize(msg = "Insufficient permissions to handle action")
    super
  end
end
