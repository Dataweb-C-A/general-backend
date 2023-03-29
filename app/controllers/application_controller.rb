class ApplicationController < ActionController::API
  include Pagy::Backend

  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message, message: "Not authorize", redirect: "https://admin.rifa-max.com/login", statusCode: '401' }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message, message: "Not authorize", redirect: "https://admin.rifa-max.com/login", statusCode: '401' }, status: :unauthorized
    end
  end
end