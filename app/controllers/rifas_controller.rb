class RifasController < ApplicationController
  def index
    @rifas = Rifa.includes([:user]).order(:id)
    @pagy, @rifa = pagy(@rifas, items: params[:items] || 20, page: params[:page])
    render json: {
      rifas: @rifa.reverse.as_json,
      status_code: 200,
      metadata: {
        page: @pagy.page,
        count: @pagy.count,
        items: @pagy.items,
        pages: @pagy.pages
      },
    }, status: :ok
  end

  def actives
    @rifas = Rifa.includes([:user]).where(is_send: false).order(:id)
    @pagy, @rifa = pagy(@rifas, items: params[:items] || 20, page: params[:page])
    render json: {
      rifas: @rifa.reverse.as_json,
      status_code: 200,
      metadata: {
        page: @pagy.page,
        count: @pagy.count,
        items: @pagy.items,
        pages: @pagy.pages
      },
    }, status: :ok
  end

  def create
    @rifa = Rifa.new(rifa_params)
    if @rifa.save
      render json: @rifa, status: :created
    else
      render json: @rifa.errors, status: :unprocessable_entity
    end
  end

  def update
    if @rifa.update(rifa_params)
      render json: @rifa, status: :ok
    else
      render json: @rifa.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @rifa.destroy
  end

  private 

  def find_rifa
    @rifa = Rifa.find(params[:id])
  end

  def rifa_params
    params.require(:rifa).permit(
      :awardSign,
      :awardNoSign,
      :is_send,
      :rifDate,
      :expired,
      :loteria,
      :money,
      :price,
      :pin,
      :serial,
      :verify,
      :plate,
      :numbers,
      :year,
      taquillas_ids: [],
      :user_id
    )
  end
end
