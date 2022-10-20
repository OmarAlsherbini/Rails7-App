FactoryBot.define do
  factory :user_event do
    Event { nil }
    user { nil }
    user_physical_address { "MyString" }
    user_lat_long { "MyString" }
    user_performance { 1.5 }
  end
end
