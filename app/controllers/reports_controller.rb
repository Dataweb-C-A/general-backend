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
    @places = Place.where(created_at: @init_date.to_s..@end_date.to_s, agency_id: @taquilla).includes([:draw])

    render :json => {
      places: @places,
      ui: {
        commission_percentage: @user.commission_percentage.to_i,
        commission_parser: "#{@user.commission_percentage.to_s}%",
        earnings: {
          today_earnings: Place.earnings(@taquilla, Date.today),
          today_earnings_parser: "#{sprintf('%.2f', Place.earnings(@taquilla, Date.today))}$",
          agency_all_earnings: Place.earnings(@taquilla, nil),
          agency_all_earnings_parser: "#{sprintf('%.2f', Place.earnings(@taquilla, nil))}$",
          filter_agency_earnings: Place.filter_earnings(@taquilla, @init_date, @end_date),
          filter_agency_earnings_parser: "#{sprintf('%.2f', Place.filter_earnings(@taquilla, @init_date, @end_date))}$"
        }
      }
    } 
  end
end 
