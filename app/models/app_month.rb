class AppMonth < ApplicationRecord
  belongs_to :app_calendar
  belongs_to :app_year
  has_many :app_day
end
