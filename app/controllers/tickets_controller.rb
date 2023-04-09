class TicketsController <  ApplicationController
  include TimeBlock

  rescue_from ForbiddenException do |e|
    render json: { error: e.message, redirect: "https://admin.rifa-max.com/", status_code: 403 }, status: :forbidden
  end

  def index
    @rifa = Rifa.last
    @tickets = RifaTicket.last
    TimeBlock.block(Time.new(Time.now.year, Time.now.month, Time.now.day, 0, 0, 0), Time.new(Time.now.year, Time.now.month, Time.now.day, 7, 30, 0)) do
      render 'tickets/index', locals: { rifa: @rifa, tickets: @tickets }
    end
  end
end
