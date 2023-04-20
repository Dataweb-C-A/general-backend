class RifaTicketsController < ApplicationController
  def index
    redis = Redis.new
    tickets = redis.get("tickets-#{params[:rifa_id]}")
    render json: tickets
  end
end
