class DrawsController < ApplicationController
  before_action :set_draw, only: [:show]
  def index
    @draws = Draw.all.includes([:award_attachment])
    ActionCable.server.broadcast("DrawChannel", @draws)
    render json: @draws
  end

  def public_get
    if params[:user_id].present?
      @draws = Draw.find_by(owner_id: params[:user_id])
      render json: [@draws], status: :ok
    else
      render json: { message: 'No se encontraron rifas' }, status: :not_found
    end
  end

  def filter
    @draws = Draw.find_awards_by_owner(params[:owner_id])
    render json: @draws
  end

  def show
    render json: @draw
  end

  def create
    @draw = Draw.new(draw_params)
    if @draw.save
      ActionCable.server.broadcast("DrawChannel", @draw)
      render json: @draw
    else
      render json: @draw.errors, status: :unprocessable_entity
    end
  end

  private

  def set_draw
    @draw = Draw.find(params[:id])
  end

  def draw_params
    params.require(:draw).permit(:award, 
                                 :owner_id, 
                                 :title, 
                                 :first_prize, 
                                 :second_prize, 
                                 :uniq, 
                                 :init_date, 
                                 :expired_date, 
                                 :numbers, 
                                 :tickets_count, 
                                 :owner_id,
                                 :loteria, 
                                 :has_winners,
                                 :first_winner, 
                                 :second_winner, 
                                 :draw_type, 
                                 :limit, 
                                 :price_unit, 
                                 :money, 
                                 visible_taquillas_ids: [], 
                                 automatic_taquillas_ids: []
    )
  end
end
