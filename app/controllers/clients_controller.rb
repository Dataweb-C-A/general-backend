class ClientsController < ApplicationController
  before_action :set_client, only: %i[ show update destroy ]

  # GET /clients
  # GET /clients.json
  def index
    @clients = Client.all
    if params[:query]
      puts("This is the param: #{params[:query].to_s}")
      render json: Client.search(params[:query].to_s).first
    else 
      render json: @clients
    end
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    render json: @search
  end

  # POST /clients
  # POST /clients.json
  def create
    if client_params
      @client_exists = Client.find_by(dni: client_params[:dni])
      if @client_exists
        render json: { message: @client_exists }, status: :ok
      else
        @client = Client.new(client_params)
        if @client.save
          render json: @client, status: :created, location: @client
        else
          render json: @client.errors, status: :unprocessable_entity
        end
      end
    else
      render json: { message: "No client on ticket" }, status: :409
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    if @client.update(client_params)
      render :show, status: :ok, location: @client
    else
      render json: @client.errors, status: :unprocessable_entity
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def client_params
      params.require(:clients).permit(:name, :dni, :email, :phone)
    end

    def search
      @search = Client.search(params[:query].to_s)
    end
end
