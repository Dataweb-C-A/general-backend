class ApplicationController < ActionController::API
  include Pagy::Backend
  # include Authenticate

  # rescue_from InsufficientPermissionsError do |e|
  #   render json: { error: e.message, redirect: "https://admin.rifa-max.com/", status_code: 403 }, status: :forbidden
  # end

  def not_found
    render json: { error: 'Not found' }
  end

  def menu
    render json: [
                   {option: "1", option_parser: 1, combo_price: 1, money: "$"}, {option: "6", option_parser: 6, combo_price: 5, money: "$"}, {option: "15", option_parser: 15, combo_price: 10, money: "$"}
                 ], status: :ok
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

  def stadium_pot
    redis = Redis.new
    sold = redis.get('fifty:8').gsub(/\[|\]|\s/, '').split(',').map(&:to_i).length
    render json: {
      monumental: {
        playdate: Date.today,
        tickets_sold: sold,
        founds: (sold * 0.95).round(2),
        pot_founds: ((sold * 0.95) * 0.5).round(2),
      }
    }, status: :ok
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
