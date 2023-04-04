class WalletsController < ApplicationController
  def index
    @wallets = Wallet.includes([:user])
    render json: @wallets, status: :ok
  end
end
