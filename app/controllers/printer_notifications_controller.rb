class PrinterNotificationsController < ApplicationController
  def index
    @notification = PrinterNotification.lock('FOR UPDATE SKIP LOCKED').where(is_printed: false).first
    redis = Redis.new
    if @notification
      @notification.is_printed = true
      @notification.save
      render json: [{notification: @notification}], status: :ok
    else
      render json: { error: "Not messages to print" }, status: :not_found
    end
  end
end
