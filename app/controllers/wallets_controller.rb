class WalletsController < ApplicationController
  def index
    @wallets = Wallet.all
    render json: @wallets, status: :ok
  end
end
