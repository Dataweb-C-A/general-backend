class TicketsController <  ApplicationController
  include TimeBlock

  # before_action :check_hibernation_time

  HIBERNATION_START_TIME = Time.new(Time.now.year, Time.now.month, Time.now.day, 4, 0, 0)
  HIBERNATION_END_TIME = Time.new(Time.now.year, Time.now.month, Time.now.day, 19, 30, 0)

  rescue_from ForbiddenException do |e|
    render json: { error: e.message, redirect: "https://admin.rifa-max.com/", status_code: 403 }, status: :forbidden
  end

  def index
    @draw = Draw.find(params[:draw_id])
    @place = Place.find(params[:plays])
    @agency = params[:agency_id].present? ? Whitelist.find_by(user_id: params[:agency_id]) : Whitelist.find_by(user_id: @draw.owner_id)
    render 'place/index', locals: { draw: @draw, place: @place, agency: @agency }
  end

  private

  def tickets_params 
    params.require(:rifa_ticket).permit(:rifa_id, :user_id, :ticket_number, :ticket_status)
  end

  def check_hibernation_time
    TimeBlock.block(HIBERNATION_START_TIME, HIBERNATION_END_TIME)
  end
end
