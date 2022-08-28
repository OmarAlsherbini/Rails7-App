class AppYear < ApplicationRecord
  belongs_to :app_calendar
  has_many :app_month
  has_many :app_day
end
