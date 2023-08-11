# == Schema Information
#
# Table name: denominations
#
#  id         :bigint           not null, primary key
#  ammount    :float
#  category   :string
#  label      :string
#  money      :string
#  power      :float
#  quantity   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quadre_id  :bigint           not null
#
# Indexes
#
#  index_denominations_on_quadre_id  (quadre_id)
#
# Foreign Keys
#
#  fk_rails_...  (quadre_id => quadres.id)
#
class DenominationSerializer < ActiveModel::Serializer
  attributes :value, :short_value, :quantity, :power, :category, :label, :ammount, :total

  def value
    case object.money
    when '$'
      'Dolares'
    when 'COP'
      'Pesos colombianos'
    when'Bs.D'
      'Bolivares'
    else
      'No definido'
    end
  end
  
  def total
    if object.quantity != nil
      object.quantity * object.power
    else
      nil
    end
  end

  def short_value
    object.money
  end
end
