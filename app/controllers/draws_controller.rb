class DrawsController < ApplicationController
  before_action :set_draw, only: [:show]
  
  def index
    @draws = Draw.last
    render json: [@draws]
  end

  def fifty
    @draws = Draw.where(draw_type: 'To-Infinity', award: nil, ads: nil)
    render json: @draws, status: :ok
  end

  def public_get
    if params[:user_id].present? && Draw.validate_draw_access(params[:user_id], request.headers[:Authorization])
      type = params[:type]

      if type == 'terminales'
        @draws = Draw.where("visible_taquillas_ids @> ARRAY[?]::integer[] OR visible_taquillas_ids = ARRAY[]::integer[]", params[:user_id]).where(tickets_count: 100)
      elsif type == 'triples'
        @draws = Draw.where("visible_taquillas_ids @> ARRAY[?]::integer[] OR visible_taquillas_ids = ARRAY[]::integer[]", params[:user_id]).where(tickets_count: 1000)
      else
        @draws = Draw.where("visible_taquillas_ids @> ARRAY[?]::integer[] OR visible_taquillas_ids = ARRAY[]::integer[]", params[:user_id])
      end

      @draws.each do |draw|
        if draw.draw_type == "Progressive"
          if (Draw.progress(draw.id)[:current].to_i >= draw.limit && draw.expired_date == nil)
            Draw.where(id: draw.id).update_all(expired_date: Date.today + 3)
          end
        end
        if draw.expired_date
          if draw.expired_date <= Time.now
            draw.is_active = false
          end
        end
      end

      render json: @draws, status: :ok
    else
      render json: { message: 'No autorizado' }, status: :forbidden
    end
  end

  def all
    @draws = Draw.all
    render json: @draws, status: :ok
  end

  def create
    if Draw.validate_draw_access(draw_params[:owner_id], request.headers[:Authorization])
      @draw = Draw.new(draw_params)

      puts params[:draw]
      
      if @draw.save
        render json: @draw
      else
        render json: { errors: @draw.errors }, status: :unprocessable_entity
      end
    else
      render json: { message: 'No autorizado' }, status: :forbidden
    end
  end

  def find
    if params[:id]
      @draw_finder = Draw.find(params[:id])
      render json: @draw_finder
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
                                 :loteria,
                                 :has_winners,
                                 :first_winner,
                                 :second_winner,
                                 :draw_type,
                                 :limit,
                                 :price_unit,
                                 :money,
                                 :ads,
                                 :award,
                                 :location,
                                 :foundation,
                                 :visible_taquillas_ids
    ) 
  end
end
