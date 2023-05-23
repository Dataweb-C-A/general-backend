class ExchangeJob
  include Sidekiq::Job
  include HTTParty
  
  def change_exchange_usd()
    response = HTTParty.get('https://s3.amazonaws.com/dolartoday/data.json')
    
    if response.success?
      value = response['USD']['promedio_real'].to_f
      Exchange.update(value: value, day: Time.now.in_time_zone("Caracas").to_date())
    end
  end
end
