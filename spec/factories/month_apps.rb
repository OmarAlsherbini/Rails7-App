FactoryBot.define do
  factory :month_app do
    calendar_app
    month {1}
    current_year {2022}
    name {"January"}
    days {31}
    numSpace {6}
  end
end
