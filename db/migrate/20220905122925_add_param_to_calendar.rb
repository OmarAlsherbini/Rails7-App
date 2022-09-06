class AddParamToCalendar < ActiveRecord::Migration[7.0]
  def change
    add_column :calendar_apps, :n_mon_span, :int, default: 6
    add_column :calendar_apps, :n_yr_span, :int, default: 1
    add_column :calendar_apps, :include_current_month_in_past, :bool, default: true
  end
end
