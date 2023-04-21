class StatsController < ApplicationController
  before_action :authorize_request

  def index 
    render json: Rifa.stats(@current_user)
  end
end
