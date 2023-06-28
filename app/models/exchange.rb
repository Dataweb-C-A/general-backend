# == Schema Information
#
# Table name: exchanges
#
#  id            :bigint           not null, primary key
#  automatic     :boolean          default(FALSE)
#  variacion_bs  :float
#  variacion_cop :float            not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Exchange < ApplicationRecord
  include HTTParty
  
  after_create :get_exchange
  
  def get_exchange
    @base_uri = 'https://s3.amazonaws.com/dolartoday/data.json'
    if self.automatic
      response = HTTParty.get(@base_uri)
      if response.code == 200
        self.variacion_bs = JSON.parse(response.body)["USD"]["promedio"]
        self.save
      end
    end
  end
end
