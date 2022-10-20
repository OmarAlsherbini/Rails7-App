FactoryBot.define do
  factory :event do
    month_app { nil }
    name { "MyString" }
    all_day { false }
    start_date { "2022-10-18 12:36:58" }
    end_date { "2022-10-18 12:36:58" }
    event_type { 1 }
    event_details { "MyString" }
    event_value { 1 }
  end
end
