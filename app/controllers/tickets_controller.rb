class TicketsController < ActionController::Base
  def index
    @rifa = Rifa.last
    @tickets = RifaTicket.last
    render 'tickets/index'
  end
end
