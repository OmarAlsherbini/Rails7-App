FactoryBot.define do
  factory :calendar_app do
    n_mon_span {6}
    n_yr_span {1}
    include_current_month_in_past {true}
  end
end