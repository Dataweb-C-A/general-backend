FactoryBot.define do
  factory :ticket do
    play { "MyString" }
    number { 1 }
    ticket_nro { 1 }
    serial { "MyString" }
    is_sold { false }
    sold_at { false }
  end
end
