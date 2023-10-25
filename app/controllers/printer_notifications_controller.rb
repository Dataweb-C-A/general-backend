class PrinterNotificationsController < ApplicationController
  def index
    @notification = PrinterNotification.where(is_printed: false).last
    redis = Redis.new
    if @notification
      @notification.update(is_printed: true)
      render json: [{notification: @notification}], status: :ok
    else
      render json: { error: "Not messages to print" }, status: :not_found
    end
  end
end
