class DrawsController < ApplicationController
  before_action :set_draw, only: [:show]
  def index
    @draws = Draw.all.includes([:award_attachment])
    ActionCable.server.broadcast("DrawChannel", @draws)
    render json: @draws
  end

  def public_get
    if params[:user_id].present? && Draw.validate_draw_access(params[:user_id], request.headers[:Authorization])
      @draws = Draw.find_by(owner_id: params[:user_id])
      render json: [@draws], status: :ok
    else
      render json: { message: 'No autorizado' }, status: :forbidden
    end
  end

  def create
    if params[:user_id].present? && params[:role] === 'Admin' && Draw.validate_draw_access(params[:user_id], request.headers[:Authorization])
      Draw.new(draw_params)
      if @draw.save
        render json: @draw
      else
        render json: @draw.errors, status: :unprocessable_entity
      end
    else
      render json: { message: 'No autorizado' }, status: :forbidden
    end
  end

  def filter
    @draws = Draw.find_awards_by_owner(params[:owner_id])
    render json: @draws
  end

  def show
    render json: @draw
  end

  private

  def set_draw
    @draw = Draw.find(params[:id])
  end

  def draw_params
    params.require(:draw).permit(:owner_id, 
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
                                 :ads,
                                 award: [], 
                                 visible_taquillas_ids: [], 
                                 automatic_taquillas_ids: []
    )
  end
end
