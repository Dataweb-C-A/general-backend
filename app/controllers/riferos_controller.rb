class RiferosController < ApplicationController
  

  def index
    @riferos = User.find(1).taquilla.users_ids.map do |rifero|
      User.find(rifero)
    end

    render json: { riferos: @riferos, currentUser: @current_user }, status: :ok
  end
end
