class TaquillasController < ApplicationController
  def create
    @taquilla = Taquilla.new(taquilla_params)
    if @taquilla.save
      render json: @taquilla, status: :created
    else
      render json: @taquilla.errors, status: :unprocessable_entity
    end
  end

  def show
    @taquilla = Taquilla.includes(:owner, :riferos).all
    render json: @taquilla.as_json(include: {
      owner: { only: [:id, :name, :email] },
    })
  end

  private

  def taquilla_params
    params.require(:taquilla).permit(:name, :owner_id, riferos_ids: [])
  end
end
