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

  def to_infinity
    redis = Redis.new
    place_id = params[:id]
    part = params[:part]

    if place_id.present?
      # if Place.validate_tickets(place_id)
        places = JSON.parse(redis.get("places:#{place_id}:#{part || 1}"))

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
      # else
      #   render json: { message: 'No autorizado' }, status: :forbidden
      # end
    else
      render json: { message: 'No autorizado' }, status: :forbidden
    end
  end

  def sell_infinity
    render json: GenerateDrawPlacesJob.new.sell_random(place_params[:draw_id], params[:quantity], place_params[:agency_id]), status: :ok
  end

  def sell_places
    return unless place_params[:agency_id]
    if place_params[:user_id].present? && Draw.validate_draw_access(place_params[:user_id], request.headers[:Authorization])
      if place_params[:agency_id] && Whitelist.find_by(user_id: place_params[:agency_id])
        GenerateDrawPlacesJob.new.sell_places(place_params[:draw_id], place_params[:place_nro], place_params[:agency_id])[:completed] ? (
          render json: { 
            place: Place.last, 
            redirect: "https://#{ENV["HOST"]}/tickets?place_position=#{place_params[:place_nro]}", 
            error: nil, 
            completed: true, 
            status: 201 
          }, status: :ok
        ) : (
          render json: { 
            error: 'Los lugares ya estan vendidos', 
            completed: false, 
            status: 401 
          }, status: :unprocessable_entity
        )
      else
        render json: { 
          error: 'Unauthorized!', 
          code: 401 
        }, status: :unauthorized
      end
    else
      render json: { 
        error: 'Unauthorized!', 
        code: 401 
      }, status: :unauthorized
    end
  end

  def printer_infinity 
    @draw = Draw.find(params[:draw_id])
    @agency = Whitelist.find_by(user_id: params[:agency_id])

    place_numbers = params[:plays].to_s.tr('[]', '').tr(',', ' ')

    atributos_array = place_numbers.split(' ')

@eighty_mm = <<-PLAIN_TEXT
                   RIFAMAX\n------------------------------------------------\n                   NUMEROS\n#{atributos_array.each do |a| if(a.to_i <= 999) "#{a}0 " else "#{a} " end}\n------------------------------------------------\n                   PREMIOS\n#{@draw.first_prize}\n------------------------------------------------\nPrecio:    	      	      10$\nTipo:    	      	      50-50\nAgencia:    	      	      #{@agency.name}\nTicket numero:    	      #{@draw.numbers}\nFecha de venta:    	      #{DateTime.now.strftime("%d/%m/%Y %H:%M")}\nFecha sorteo:    	      #{@draw.created_at.strftime("%d/%m/%Y %H:%M")}\n------------------------------------------------\nJugadas: #{atributos_array.length}    	      	      Total: #{atributos_array.length * 10}$\n------------------------------------------------#{false ? "\n                   CLIENTE\n------------------------------------------------\nNombre:    	      	      #{@client.name}\nCedula:    	      	      #{@client.dni}\nTelefono:    	      	      #{@client.phone}\n------------------------------------------------\n" : "\n\n\n\n\n"}
PLAIN_TEXT

    render plain: @eighty_mm
  end

  def print_text
    @draw = Draw.find(params[:draw_id])
    @place = Place.find(params[:plays])
    @agency = Whitelist.find_by(user_id: @place.agency_id)
    #@client = Client.find(@place.client_id)
    
    place_numbers = @place.place_numbers.to_s.tr('[]', '')
  
    qr_code_url = "https://#{ENV["HOST"]}/tickets?draw_id=#{@draw.id}&plays=#{@place.id}"
    qr_code = "IMAGE|0|-20|150|150|#{ApplicationRecord.generate_qr(qr_code_url)}"
  
@eighty_mm = <<-PLAIN_TEXT
------------------------------------------------\n                   NUMEROS\n#{place_numbers}\n------------------------------------------------\n                   PREMIOS\n#{@draw.first_prize}\n------------------------------------------------\nPrecio:    	      	      #{@draw.price_unit}0$\nTipo:    	      	      Terminal(00-99)\nAgencia:    	      	      #{@agency.name}\nTicket numero:    	      #{@draw.numbers}\nFecha de venta:    	      #{@place.created_at.strftime("%d/%m/%Y %H:%M")}\nFecha sorteo:    	      #{@draw.created_at.strftime("%d/%m/%Y %H:%M")}\nProgreso:    	      	      #{Draw.progress(@draw.id)[:current]}%\n------------------------------------------------\nJugadas: #{@place.place_numbers.length}    	      	      Total: #{@place.place_numbers.length * @draw.price_unit}0$\n------------------------------------------------#{false ? "\n                   CLIENTE\n------------------------------------------------\nNombre:    	      	      #{@client.name}\nCedula:    	      	      #{@client.dni}\nTelefono:    	      	      #{@client.phone}\n------------------------------------------------\n" : "\n"}
PLAIN_TEXT

@qr_print = <<-PLAIN_TEXT
#{qr_code}
PLAIN_TEXT

@fifty_eight_mm = <<-PLAIN_TEXT
---------------------------------\n            NUMEROS\n#{place_numbers}\n---------------------------------\n            PREMIOS\n10000$\n---------------------------------\nPrecio:    	 #{@draw.price_unit}0$\nTipo:            #{@draw.type_of_draw}(00-99)\nAgencia:    	 #{@agency.name}\nTicket Num:      #{@draw.numbers}\nFecha venta:     #{@place.created_at.strftime("%d/%m/%Y %H:%M")}\nFecha sorteo:    #{@draw.expired_date ? @draw.expired_date.strftime("%d/%m/%Y") : "Por anunciar"}\nProgreso:    	 #{Draw.progress(@draw.id)[:current]}%\n---------------------------------\nJugadas: #{place_numbers.length}      Total: #{@draw.price_unit * place_numbers.length}$\n---------------------------------\n\n\n\n\n
PLAIN_TEXT
  
    if params[:qr] == "on"
      render plain: @qr_print
    elsif params[:logo] == 'yes'
      render plain: "IMAGE|10|10|150|150|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"
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
    params.require(:place).permit(:client, :quantity, :draw_id, :agency_id, :user_id, place_nro: [])
  end
end
