class AppCalendar < ApplicationRecord
    has_many :app_year
    has_many :app_month
    has_many :app_day
end
