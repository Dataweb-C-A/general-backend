class PlacesController < ApplicationController
  def index
    redis = Redis.new
    place_id = params[:id]

    if place_id.present?
      if Place.validate_tickets(place_id)
        places = JSON.parse(redis.get("places:#{place_id}"))
        render json: places
      else
        render json: { message: 'No autorizado' }, status: :forbidden
      end
    else
      render json: { message: 'No autorizado' }, status: :forbidden
    end
  end

  private

  def place_params
    params.require(:place).permit(:number, :place_nro, :sold_at, :client_id, :draw_id)
  end
end