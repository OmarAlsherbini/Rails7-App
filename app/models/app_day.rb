class AppDay < ApplicationRecord
  belongs_to :app_calendar
  belongs_to :app_year
  belongs_to :app_month
end
