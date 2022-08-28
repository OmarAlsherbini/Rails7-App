class AddForeignKeyToAppCalendar < ActiveRecord::Migration[7.0]
  def change
    add_column :app_calendars, :current_year, :bigint
    add_column :app_calendars, :next_year, :bigint
    add_column :app_calendars, :past_year, :bigint
    add_column :app_calendars, :current_month, :bigint
    add_column :app_calendars, :next_month, :bigint
    add_column :app_calendars, :previous_month, :bigint
    add_foreign_key :app_calendars, :app_years, column: :current_year
    add_foreign_key :app_calendars, :app_years, column: :next_year
    add_foreign_key :app_calendars, :app_years, column: :past_year
    add_foreign_key :app_calendars, :app_months, column: :current_month
    add_foreign_key :app_calendars, :app_months, column: :next_month
    add_foreign_key :app_calendars, :app_months, column: :previous_month

  end
end
