class DenominationsController < ApplicationController
  before_action :set_denomination, only: %i[ show update destroy ]

  # GET /denominations
  # GET /denominations.json
  def index
    @denominations = Denomination.all
  end

  # GET /denominations/1
  # GET /denominations/1.json
  def show
  end

  # POST /denominations
  # POST /denominations.json
  def create
    @denomination = Denomination.new(denomination_params)
    if @denomination.save
      render json: @denomination, status: :created, location: @denomination
    else
      render json: @denomination.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /denominations/1
  def update
#    if Draw.validate_draw_access(denomination_params[:user_id], request.headers[:Authorization])
      if @denomination.update(denomination_params)
        render json: @denomination, status: :ok, location: @denomination
      else
        render json: @denomination.errors, status: :unprocessable_entity
      end
#    else
#      render json: { message: "No autorizado" }, status: :forbidden
#    end
  end

  # DELETE /denominations/1
  # DELETE /denominations/1.json
  def destroy
    @denomination.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_denomination
      @denomination = Denomination.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def denomination_params
      params.require(:denomination).permit(:user_id, :money, :power, :quantity, :category, :label, :ammount)
    end
end
