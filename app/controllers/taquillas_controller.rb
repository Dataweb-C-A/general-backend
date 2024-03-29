class TaquillasController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :find_taquillas, except: [:index, :create]

  def index
    @taquilla = Taquilla.includes([:owner]) #.where(owner: @current_user)
    @pagy, @taquillas = pagy(@taquilla, items: params[:items] || 5, page: params[:page])
    render json: {
      taquillas: @taquillas.as_json(include: [:owner, :users]),
      metadata: {
        page: @pagy.page,
        count: @pagy.count,
        items: @pagy.items,
        pages: @pagy.pages
      },
      status_code: 200
    }
  end

  def show
    render json: { taquilla: @taquilla.as_json(include: [:owner, :users]) }, status: :ok
  end
  
  def create
    @taquilla = Taquilla.new(taquilla_params)
    if @taquilla.save
      render json: @taquilla, status: :created
    else
      render json: @taquilla.errors, status: :unprocessable_entity
    end
  end


  private

  def find_taquillas
    @taquilla = Taquilla.find(params[:_id])
  end

  def taquilla_params
    params.require(:taquilla).permit(
      :name, 
      :owner_id, 
      users_ids: []
    )
  end
end
