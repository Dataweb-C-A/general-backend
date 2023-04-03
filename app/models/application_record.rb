class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def allow_sell_tickets?(user_id, rifa_id)
    User.find(user_id) === Rifa.find(rifa_id).taquilla
  end
end
