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
class ExchangeSerializer < ActiveModel::Serializer
  attributes :BsD, :COP, :fecha, :hora, :automatico

  def BsD 
    "Bs. #{object.variacion_bs.to_s.tr('.', ',')}"
  end

  def COP
    "#{object.variacion_cop} COP"
  end

  def automatico
    object.automatic
  end

  def fecha
    object.created_at.strftime("%d/%m/%Y")
  end

  def hora
    object.created_at.strftime("%H:%M")
  end
end
