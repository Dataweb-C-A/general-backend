class DrawChannel < ApplicationCable::Channel
  def subscribe
    ActionCable.server.broadcast("draw_channel", { message: "Draws connection successfully" })
  end
end
