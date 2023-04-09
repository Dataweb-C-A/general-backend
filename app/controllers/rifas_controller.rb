class RifasController < ApplicationController
  include Authenticate

  before_action :authorize_request
  before_action :find_rifa, only: [:show, :update, :destroy]
  
  def index
    permit_access_to_riferos!
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
    @rifas = Rifa.active.includes([:user]).order(:id)
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

  def expireds
    @rifas = Rifa.expired.includes([:user]).order(:id)
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
      :user_id,
      :taquillas_ids,
    )
  end
end
