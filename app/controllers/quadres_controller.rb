class QuadresController < ApplicationController
  def index
    Quadre.create_quadres
    @quadre = Quadre.where(agency_id: params[:agency_id], day: Date.today)
    if (@quadre.length != 0)
      render json: @quadre, status: :ok
    else
      render json: { message: 'No autorizado' }, status: :forbidden
    end
  end

  private
  
  def quadre_params
  end
end
