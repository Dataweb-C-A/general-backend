class Taquilla < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_and_belongs_to_many :riferos, class_name: 'User'

  def as_json(options={})
    TaquillaSerializer.new(self).as_json
  end
end
