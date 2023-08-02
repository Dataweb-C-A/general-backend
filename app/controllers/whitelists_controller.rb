class WhitelistsController < ApplicationController
  def index
    @whitelists = Whitelist.all
    render json: @whitelists, status: :ok
  end

  def create 
    @whitelist = Whitelist.new(whitelist_params)
    if @whitelist.save
      render json: @whitelist, status: :created
    else
      render json: @whitelist.errors, status: :unprocessable_entity
    end
  end

  private 

  def whitelist_params
    params.require(:whitelist).permit(:user_id, :name, :role, :email, :commission_percentage)
  end
end
