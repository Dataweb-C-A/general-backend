class AuthDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  
  def guard?(user, role_required)
    @current_user = user
    @role_required = role_required
    
    if @current_user.nil?
      return false
    end

    if @current_user.role == User.find_role(@role_required)
      return true
    end

    return false
  end
end