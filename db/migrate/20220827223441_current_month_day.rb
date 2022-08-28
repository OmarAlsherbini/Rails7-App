class CurrentMonthDay < ActiveRecord::Migration[7.0]
  def change
    add_column :app_calendars, :two_next_year, :bigint
    add_column :app_calendars, :two_past_year, :bigint
    add_foreign_key :app_calendars, :app_years, column: :two_next_year
    add_foreign_key :app_calendars, :app_years, column: :two_past_year
  end
end
