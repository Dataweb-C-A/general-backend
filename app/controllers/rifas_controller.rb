class RifasController < ApplicationController
  def index
    @rifas = Rifa.all
    render json: @rifas
  end
end
