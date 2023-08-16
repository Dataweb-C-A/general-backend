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
      render :show, status: :created, location: @denomination
    else
      render json: @denomination.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /denominations/1
  # PATCH/PUT /denominations/1.json
  def update
    if @denomination.update(denomination_params)
      render :show, status: :ok, location: @denomination
    else
      render json: @denomination.errors, status: :unprocessable_entity
    end
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
      params.fetch(:denomination, {})
    end
end
