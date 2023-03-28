class ProfilesController < ApplicationController
  before_action :authorize_request, except: [:find]

  # GET /my-profile
  def index
    render json: { profile: @current_user, statusCode: 200 }, status: :ok
  end

  # GET /profiles/{username}
  def find
    @user = User.find_by_username!(params[:username])
    render json: @user, status: :ok
  end

  # PUT /my-profile
  def update
    unless @current_user.update(user_params)
      render json: { errors: @current_user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.permit(
      :avatar, :name, :username, :email, :password, :password_confirmation
    )
  end
end
