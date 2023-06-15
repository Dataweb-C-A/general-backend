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

  def print_text
    @draw = Draw.find(params[:draw_id])
    @place = Place.find(params[:plays])
    @agency = Whitelist.find(@draw.owner_id)
    
    @eighty_mm = "	    RIFAMAX
---------------------------------
            NUMEROS:
#{@place.place_numbers}
---------------------------------
Premio:   	  #{@draw.first_prize}
Precio:       	  #{@draw.price_unit}0$
Tipo:	          Terminal(00-99)
Agencia:    	  #{@agency.name}
Ticket numero:    #{@draw.numbers}
Fecha de venta:   #{@place.created_at.strftime("%d/%m/%Y %H:%M")}
Tipo sorteo:	  #{@draw.draw_type}
Fecha sorteo: 	  #{@draw.created_at.strftime("%d/%m/%Y %H:%M")}
Progreso: 	  #{Draw.progress(@draw.id)[:current]}%
---------------------------------
Jugadas: #{@place.place_numbers.length} 	  Total: #{@place.place_numbers.length * @draw.price_unit}0$
---------------------------------
            CLIENTE
---------------------------------
Nombre:		  Javier Diaz
Cedula:		  V-29.543.140
Telefono:	  0412-1688466
---------------------------------
#{ApplicationRecord.generate_qr("http://localhost:3000/tickets?draw_id=#{@draw.id}&plays=#{@place.id}")}
"

    @fifty_six_mm = "----------- CUT -----------

        RIFAMAX
----------------------------
        NUMEROS:
#{@place.place_numbers}
----------------------------
Premio:      #{@draw.first_prize}
Precio:      #{@draw.price_unit}0$
Tipo:	     Terminal(00-99)
Agencia:     #{@agency.name}
Ticket num:  #{@draw.numbers}
Fecha venta: #{@place.created_at.strftime("%d/%m/%Y %H:%M")}
Tipo sorteo: #{@draw.draw_type}
Fecha:	     #{@draw.created_at.strftime("%d/%m/%Y %H:%M")}
Progreso:    #{Draw.progress(@draw.id)[:current]}%
----------------------------
Jugadas: #{@place.place_numbers.length}   Total: #{@place.place_numbers.length * @draw.price_unit}0$
----------------------------
         CLIENTE
----------------------------
Nombre:	     Javier Diaz
Cedula:	     V-29.543.140
Telefono:    0412-1688466
----------------------------

----------- CUT ------------+"

    if params[:print] == "80mm"
      render plain: @eighty_mm
    else
      render plain: @fifty_six_mm
    end
  end

  private

  def place_params
    params.require(:place).permit(:client, :draw_id, place_nro: [])
  end
end