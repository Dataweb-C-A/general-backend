FactoryBot.define do
  factory :rifa do
    awardSign { "MyString" }
    awardNoSign { "MyString" }
    is_send { false }
    rifDate { "2023-03-29" }
    expired { "2023-03-29" }
    loteria { "MyString" }
    money { "MyString" }
    user { nil }
    price { 1.5 }
    pin { "MyString" }
    serial { "MyString" }
    verify { false }
    plate { "MyString" }
    numbers { 1 }
    year { 1 }
  end
end
