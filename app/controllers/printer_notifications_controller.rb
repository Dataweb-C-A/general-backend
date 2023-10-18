class PrinterNotificationsController < ApplicationController
  def index
    @notification = PrinterNotification.where(user_id: params[:user_id], is_printed: false).last
    if @notification
      @notification.update(is_printed: true)
      render json: [@notification], status: :ok
    else
      render json: { error: "Not messages to print" }, status: :not_found
    end
  end
end
