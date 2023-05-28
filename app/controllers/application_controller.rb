class ApplicationController < ActionController::API
  include Pagy::Backend
  # include Authenticate

  # rescue_from InsufficientPermissionsError do |e|
  #   render json: { error: e.message, redirect: "https://admin.rifa-max.com/", status_code: 403 }, status: :forbidden
  # end

  def not_found
    render json: { error: 'Not found' }
  end

  def app_version_check
    if request.headers['App-Version'] != '1.0.0'
      render json: { error: 'Update version of APP' }, status: :unauthorized
    else 
      render json: { message: 'App'}
    end
  end

  def test
    render json: {
      message: "Test",
      test: request.headers['Authorization'],
      testtwo: params[:userid]
    }
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message, message: "Not authorize", redirect: "https://admin.rifa-max.com/login", status_code: 401 }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message, message: "Not authorize", redirect: "https://admin.rifa-max.com/login", status_code: 401 }, status: :unauthorized
    end
  end
end