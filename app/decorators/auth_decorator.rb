class AuthDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  
  def has_role(current_user, role) 
    @user = current_user.roles.include?(role)
    
    if !@user
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
