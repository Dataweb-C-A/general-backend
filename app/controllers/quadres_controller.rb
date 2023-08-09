class QuadresController < ApplicationController
  def index
    @quadre = Quadre.all
    render json: @quadre, status: :ok
  end

  private
  
  def quadre_params
  end
end
