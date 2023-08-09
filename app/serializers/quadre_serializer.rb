# == Schema Information
#
# Table name: quadres
#
#  id         :bigint           not null, primary key
#  day        :date
#  gastos     :float
#  total      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  agency_id  :integer
#
class QuadreSerializer < ActiveModel::Serializer
  attributes :current_day, :created_at, :total_bsd, :denominations_in_bsd, :denominations_in_dollar, :denominations_in_cop

  def current_day
    object.day.strftime('%d/%m/%Y')
  end

  def total_bsd
    object.total
  end

  def denominations_in_bsd
    ActiveModel::Serializer::CollectionSerializer.new(object.denomination.where(money: 'Bs.D'), serializer: DenominationSerializer)
  end

  def denominations_in_dollar
    ActiveModel::Serializer::CollectionSerializer.new(object.denomination.where(money: '$'), serializer: DenominationSerializer)
  end
  
  def denominations_in_cop
    ActiveModel::Serializer::CollectionSerializer.new(object.denomination.where(money: 'COP'), serializer: DenominationSerializer)
  end
end
