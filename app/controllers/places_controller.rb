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
        render json: { place: Place.last, redirect: "https://#{ENV["HOST"]}/tickets?place_position=#{place_params[:place_nro]}" }, status: :ok
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
    @agency = Whitelist.find_by(user_id: @draw.owner_id)
    #@client = Client.find(@place.client_id)
    
    place_numbers = @place.place_numbers.to_s.tr('[]', '')
  
    qr_code_url = "https://#{ENV["HOST"]}/tickets?draw_id=#{@draw.id}&plays=#{@place.id}"
    qr_code = "IMAGE|0|-20|150|150|#{ApplicationRecord.generate_qr(qr_code_url)}"
  
@eighty_mm = <<-PLAIN_TEXT
                   RIFAMAX\n------------------------------------------------\n                   NUMEROS\n#{place_numbers}\n------------------------------------------------\n                   PREMIOS\n#{@draw.first_prize}\n------------------------------------------------\nPrecio:    	      	      #{@draw.price_unit}0$\nTipo:    	      	      Terminal(00-99)\nAgencia:    	      	      #{@agency.name}\nTicket numero:    	      #{@draw.numbers}\nFecha de venta:    	      #{@place.created_at.strftime("%d/%m/%Y %H:%M")}\nFecha sorteo:    	      #{@draw.created_at.strftime("%d/%m/%Y %H:%M")}\nProgreso:    	      	      #{Draw.progress(@draw.id)[:current]}%\n------------------------------------------------\nJugadas: #{@place.place_numbers.length}    	      	      Total: #{@place.place_numbers.length * @draw.price_unit}0$\n------------------------------------------------#{false ? "\n                   CLIENTE\n------------------------------------------------\nNombre:    	      	      #{@client.name}\nCedula:    	      	      #{@client.dni}\nTelefono:    	      	      #{@client.phone}\n------------------------------------------------\n" : "\n"}
PLAIN_TEXT

@qr_print = <<-PLAIN_TEXT
#{qr_code}
PLAIN_TEXT

@fifty_eight_mm = <<-PLAIN_TEXT
            RIFAMAX\n---------------------------------\n            NUMEROS\n#{place_numbers}\n---------------------------------\n            PREMIOS\n10000$\n---------------------------------\nPrecio:    	 #{@draw.price_unit}0$\nTipo:            #{@draw.type_of_draw}(00-99)\nAgencia:    	 #{@agency.name}\nTicket Num:      #{@draw.numbers}\nFecha venta:     #{@place.created_at.strftime("%d/%m/%Y %H:%M")}\nFecha sorteo:    #{@draw.expired_date ? @draw.expired_date.strftime("%d/%m/%Y") : "Por anunciar"}\nProgreso:    	 #{Draw.progress(@draw.id)[:current]}%\n---------------------------------\nJugadas: #{place_numbers.length}      Total: #{@draw.price_unit * place_numbers.length}$\n---------------------------------\n\n\n\n\n
PLAIN_TEXT
  
    if params[:qr] == "on"
      render plain: @qr_print
    else
      if params[:print] == "80mm"
        render plain: @eighty_mm
      else
        render plain: @fifty_eight_mm
      end
    end
  end
  
  private

  def place_params
    params.require(:place).permit(:client, :draw_id, :agency_id, :user_id, place_nro: [])
  end
end
