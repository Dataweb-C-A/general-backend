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
class PrinterNotification < ApplicationRecord
end
