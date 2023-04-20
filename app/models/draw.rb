class Draw < ApplicationRecord
  has_and_belongs_to_many :taquillas, class_name: 'Taquilla'
end
