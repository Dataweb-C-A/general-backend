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
    @places = Place.where(created_at: @init_date.to_s..@end_date.to_s, agency_id: @taquilla).includes(:draw)
  
    places_info = @places.map do |place|
      draw = place.draw
      price_unit = draw.price_unit
      ganancia = price_unit * place.place_numbers.length
      ganancia_final = ganancia - (ganancia * @user.commission_percentage.to_f / 100)
  
      {
        title: draw.title,
        sold_at: place.sold_at,
        price_unit: price_unit,
        ganancia: ganancia,
        ganancia_final: ganancia_final
      }
    end
  
    render :json => {
      places: places_info,
      ui: {
        commission_percentage: @user.commission_percentage.to_i,
        commission_parser: "#{@user.commission_percentage.to_s}%",
        earnings: {
          today_earnings: Place.earnings(@taquilla, Date.today),
          today_earnings_parser: "#{sprintf('%.2f', Place.earnings(@taquilla, Date.today))}$",
          agency_all_earnings: Place.earnings(@taquilla, nil),
          result_commission: "#{Place.earnings(@taquilla, Date.today) - (Place.earnings(@taquilla, Date.today) * (@user.commission_percentage.to_f / 100)).round(2)}$",
          agency_all_earnings_parser: "#{sprintf('%.2f', Place.earnings(@taquilla, nil))}$",
          filter_agency_earnings: Place.filter_earnings(@taquilla, @init_date, @end_date),
          filter_agency_earnings_parser: "#{sprintf('%.2f', Place.filter_earnings(@taquilla, @init_date, @end_date))}$"
        }
      }
    } 
  end  
end 
