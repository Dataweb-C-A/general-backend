class InboxesController < ApplicationController
  def index
    @inboxes = Inbox.where(whitelist_id: params[:agency])

    render json: @inboxes, status: :ok
  end
end
