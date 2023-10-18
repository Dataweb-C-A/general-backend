# == Schema Information
#
# Table name: printer_notifications
#
#  id                :bigint           not null, primary key
#  is_printed        :boolean          default(FALSE)
#  tickets_generated :integer          default([]), is an Array
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :integer          not null
#
FactoryBot.define do
  factory :printer_notification do
    tickets_generated { 1 }
    user_id { 1 }
    is_printed { false }
  end
end
