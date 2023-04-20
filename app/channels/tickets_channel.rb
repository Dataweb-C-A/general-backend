class TicketsChannel < ApplicationCable::Channel
  before_action :authorize_request
  def subscribed
    stream_from "tickets_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
