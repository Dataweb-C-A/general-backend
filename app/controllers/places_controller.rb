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
    return unless place_params[:agency_id]
    if place_params[:user_id].present? && Draw.validate_draw_access(place_params[:user_id], request.headers[:Authorization])
      if place_params[:agency_id] && Whitelist.find_by(user_id: place_params[:agency_id])
        GenerateDrawPlacesJob.new.sell_places(place_params[:draw_id], place_params[:place_nro], place_params[:agency_id])
        render json: { message: 'Ticket vendido', redirect: "http://localhost:3000/tickets?place_position=#{place_params[:place_nro]}" }, status: :ok
      else
        render json: { error: 'Unauthorized!', code: 401 }, status: :unauthorized
      end
    else
      render json: { error: 'Unauthorized!', code: 401 }, status: :unauthorized
    end
  end

  def print_text
    @draw = Draw.find(params[:draw_id])
    @place = Place.find(params[:plays])
    @agency = Whitelist.find(@draw.owner_id)
    @client = Client.find(@place.client_id)
    
    place_numbers = @place.place_numbers.to_s.tr('[]', '')
  
    qr_code_url = "http://localhost:3000/tickets?draw_id=#{@draw.id}&plays=#{@place.id}"
    qr_code = "IMAGE|150|150|#{ApplicationRecord.generate_qr(qr_code_url)}"
  
@eighty_mm = <<-PLAIN_TEXT
                   RIFAMAX\n------------------------------------------------\n                   NUMEROS\n#{place_numbers}\n------------------------------------------------\n                   PREMIOS\n#{@draw.first_prize}\n------------------------------------------------\nPrecio:    	      	      #{@draw.price_unit}0$\nTipo:    	      	      Terminal(00-99)\nAgencia:    	      	      #{@agency.name}\nTicket numero:    	      #{@draw.numbers}\nFecha de venta:    	      #{@place.created_at.strftime("%d/%m/%Y %H:%M")}\nTipo sorteo:    	              #{@draw.draw_type}\nFecha sorteo:    	      #{@draw.created_at.strftime("%d/%m/%Y %H:%M")}\nProgreso:    	      	      #{Draw.progress(@draw.id)[:current]}%\n------------------------------------------------\nJugadas: #{@place.place_numbers.length}    	      	      Total: #{@place.place_numbers.length * @draw.price_unit}0$\n------------------------------------------------#{@client.present? ? "\n                   CLIENTE\n------------------------------------------------\nNombre:    	      	      #{@client.name}\nCedula:    	      	      #{@client.dni}\nTelefono:    	      	      #{@client.phone}\n------------------------------------------------\n\n\n\n\n" : "\n\n\n\n\n"}
PLAIN_TEXT

@fifty_eight_mm = <<-PLAIN_TEXT
RIFAMAX\n------------------------------------------------\n		          NUMEROS\n60\n------------------------------------------------\n		          PREMIOS\n10000$\n------------------------------------------------\nPrecio:    	      	      1.00$\nTipo:    	      	      Terminal(00-99)\nAgencia:    	      	      4 Bocas\nTicket numero:    	      633\nFecha de venta:    	      20/06/2023 09:49\nTipo sorteo:    	      	      Progressive\nFecha sorteo:    	      19/06/2023: 11:28\nProgreso:    	      	      60.0%\n------------------------------------------------\nJugadas: 1    	      	      Total: 1.00$\n-----------------------------------------------\n		          CLIENTE\n------------------------------------------------\nNombre:    	      	      Javier Diaz\nCedula:    	      	      V-29543140\nTelefono:    	      	      0412-1688466\n------------------------------------------------\n\n\n\n\n
PLAIN_TEXT
  
    if params[:print] == "80mm"
      render plain: @eighty_mm
    else
      render plain: @fifty_eight_mm
    end
  end
  
  private

  def place_params
    params.require(:place).permit(:client, :draw_id, :agency_id, :user_id, place_nro: [])
  end
end