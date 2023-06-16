# == Schema Information
#
# Table name: inboxes
#
#  id           :bigint           not null, primary key
#  message      :string
#  request_type :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  whitelist_id :bigint           not null
#
# Indexes
#
#  index_inboxes_on_whitelist_id  (whitelist_id)
#
# Foreign Keys
#
#  fk_rails_...  (whitelist_id => whitelists.id)
#
class Inbox < ApplicationRecord
  belongs_to :whitelist
end
