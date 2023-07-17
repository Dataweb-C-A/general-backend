# == Schema Information
#
# Table name: exchanges
#
#  id            :bigint           not null, primary key
#  automatic     :boolean          default(FALSE)
#  variacion_bs  :float
#  variacion_cop :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Exchange < ApplicationRecord
  include HTTParty
  require 'nokogiri'
  require 'open-uri'
  
  after_create :get_exchange

  def self.get_cop
    fx = Currencyapi::Endpoints.new(:apikey => 'cur_live_yPWZk5kwhQRmQPenFQXWUnmuZKeNEHgGCwYnR5za')

    string = fx.latest("USD", "COP")

    json_string = string.gsub(/\A"|"\z/, '').gsub('\\"', '"')

    json_object = JSON.parse(json_string)

    value = json_object['data']['COP']['value']

    value.round(2)
  end

  def self.get_bsd
    url = 'https://www.bcv.org.ve'

    html = URI.open(url)
  
    doc = Nokogiri::HTML(html)
  
    dolar_value = doc.at_css('#dolar strong').content.strip
  
    dolar_value.gsub(',', '.').to_f.round(2)
  end
  
  def get_exchange
    if self.automatic
      self.variacion_bs = Exchange.get_bsd()
      self.variacion_cop = Exchange.get_cop()
      self.save
    end
  end
end
