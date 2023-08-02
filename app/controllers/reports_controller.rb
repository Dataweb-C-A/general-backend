class ReportsController < ApplicationController
  def admin_daily_earning_reports
    @date = '2023-06-04'
    @init_date = params[:at] || Date.new(@date.to_d)
    @end_date = params[:to] || Date.today
    @draw_id = params[:draw_id]
    @places = @draw.present? ? 
    Place.where(sold_at: @init_date..@end_date, draw_id: @draw_id) : 
    Place.where(sold_at: @init_date..@end_date)
    
    render json: @places
  end

  def daily_earning_reports 
    @date = '2023-06-04'
    @init_date = params[:at] || Date.new(@date.to_d)
    @end_date = params[:to] || Date.today
    @taquilla = params[:agency_id]
    @user = Whitelist.find_by(user_id: @taquilla)
    @places = Place.where(created_at: @init_date.to_s..@end_date.to_s, agency_id: @taquilla)

    render :json => {
      places: @places,
      ui: {
        commission_percentage: @user.commission_percentage.to_i,
        commission_parser: "#{@user.commission_percentage.to_s}%",
        today_earnings: Place.today_earnings(@taquilla)
      }
    } 
  end
end
