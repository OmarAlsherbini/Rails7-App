FactoryBot.define do
  factory :event do
    month_app { rand(12..24) }
    name { "MyEvent" }
    all_day { rand(0..1).zero? }
    overwritable { rand(0..1).zero? }
    start_day { "#{rand(2022..2023)}-#{rand(1..12)}-#{rand(1..28)}"}
    end_day { "#{rand(2022..2023)}-#{rand(1..12)}-#{rand(1..28)}" }
    start_time { "#{rand(1..12)}:#{rand(1..60)}:#{rand(1..60)}" }
    end_time { "#{rand(1..12)}:#{rand(1..60)}:#{rand(1..60)}" }
    start_date { "#{rand(2022..2023)}-#{rand(1..12)}-#{rand(1..28)} #{rand(1..12)}:#{rand(1..60)}:#{rand(1..60)}" }
    end_date { "#{rand(2022..2023)}-#{rand(1..12)}-#{rand(1..28)} #{rand(1..12)}:#{rand(1..60)}:#{rand(1..60)}" }
    event_type { rand(0..1) }
    event_details { "MyEventDetails" }
    event_value { rand(0..99999) }
  end
end
