class WhitelistsController < ApplicationController
  def index
    @whitelists = Whitelist.all
    render json: @whitelists, status: :ok
  end
end
