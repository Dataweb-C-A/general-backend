require 'pagy/extras/array'

class PlacesController < ApplicationController
  include Pagy::Backend

  def index
    redis = Redis.new
    place_id = params[:id]

    if place_id.present?
      if Place.validate_tickets(place_id)
        places = JSON.parse(redis.get("places:#{place_id}"))

        @pagy, @places = pagy_array(places, items: 100, page: params[:page] || 1)

        render json: {
          places: @places,
          status_code: 200,
          metadata: {
            page: @pagy.page,
            count: @pagy.count,
            items: @pagy.items,
            pages: @pagy.pages
          }
        }, status: :ok
      else
        render json: { message: 'No autorizado' }, status: :forbidden
      end
    else
      render json: { message: 'No autorizado' }, status: :forbidden
    end
  end

  def sell_places
    GenerateDrawPlacesJob.new.sell_places(place_params[:draw_id], place_params[:place_nro])

    render json: { message: 'Ticket vendido', redirect: "http://localhost:3000/tickets?place_position=#{place_params[:place_nro]}" }, status: :ok
  end

  private

  def place_params
    params.require(:place).permit(:client, :draw_id, place_nro: [])
  end
end