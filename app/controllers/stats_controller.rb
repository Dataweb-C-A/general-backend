class StatsController < ApplicationController
  before_action :authorize_request

  def rifas_stats
    render json: Rifa.stats(@current_user)
  end
end
