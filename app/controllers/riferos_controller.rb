class RiferosController < ApplicationController
  before_action :authorize_request

  def index
    @rifero = User.where(id: User.find(@current_user.id).taquilla.users_ids).order(:id)

    @pagy, @riferos = pagy(@rifero, items: params[:items] || 5, page: params[:page])
    render json: { 
      riferos: @riferos.as_json, 
      currentUser: @current_user,
      metadata: {
        page: @pagy.page,
        count: @pagy.count,
        items: @pagy.items,
        pages: @pagy.pages
      },
      status_code: 200
    }, status: :ok
  end
end
