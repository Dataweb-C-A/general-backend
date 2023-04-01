FactoryBot.define do
  factory :rifa_ticket do
    sign { "MyString" }
    number { 1 }
    ticket_nro { 1 }
    serial { "MyString" }
    is_sold { false }
  end
end
