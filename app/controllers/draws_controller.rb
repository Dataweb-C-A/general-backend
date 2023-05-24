class DrawsController < ApplicationController
  before_action :set_draw, only: [:show]
  def index
    @draws = Draw.all.includes([:award_attachment])
    ActionCable.server.broadcast("DrawChannel", @draws)
    render json: @draws
  end

  def show
  end

  def create
  end

  private

  def set_draw
    @draw = Draw.find(params[:id])
  end

  def draw_params
    params.require(:draw).permit(:award, :title, :first_prize, :second_prize, :uniq, :init_date, :expired_date, :numbers, :tickets_count, :loteria, :has_winners, :is_active, :first_winner, :second_winner, :draw_type, :limit, :price_unit, :money, visible_taquillas_ids: [], automatic_taquillas_ids: [])
  end
end
