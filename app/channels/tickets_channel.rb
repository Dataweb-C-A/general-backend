class TicketsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "tickets_channel"
  end

  def receive(data)
    redis.set("tickets_#{data['id']}_status", data['status'])

    ActionCable.server.broadcast('tickets_channel', data)
  end
  
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private
  def redis
    # Configura la conexión a Redis aquí
    @redis ||= Redis.new
  end
end
