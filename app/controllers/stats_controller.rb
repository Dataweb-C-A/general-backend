class StatsController < ApplicationController
  def index 
    render json: {
      all: Rifa.count,
      actives: Rifa.active.count,
      expired: Rifa.expired.count,
      status_code: 200
    }
  end
end
