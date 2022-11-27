class AddFieldsToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :start_day, :date
    add_column :events, :end_day, :date
    add_column :events, :start_time, :time
    add_column :events, :end_time, :time
  end
end
