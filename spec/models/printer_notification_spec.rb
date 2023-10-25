# == Schema Information
#
# Table name: printer_notifications
#
#  id                :bigint           not null, primary key
#  is_printed        :boolean          default(FALSE)
#  tickets_generated :integer          default([]), is an Array
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  current_id        :integer
#  user_id           :integer          not null
#
require 'rails_helper'

RSpec.describe PrinterNotification, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
