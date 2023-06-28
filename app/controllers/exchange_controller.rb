class ExchangeController < ApplicationController
  def index
    if params[:last]
      @exchanges = Exchange.last
      render json: @exchanges, status: :ok
    else
      @exchanges = Exchange.all
      render json: @exchanges, status: :ok
    end
  end

  def create
    @exchange = Exchange.new(client_params)
    if @exchange.save
      render json: @exchange, status: :created
    else
      render json: @exchange.errors, status: :unprocessable_entity
    end
  end

  private

  def client_params
    params.require(:exchange).permit(:variacion_bs, :variacion_cop, :automatic)
  end
end
