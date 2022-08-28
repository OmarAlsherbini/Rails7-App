class CreateAppCalendars < ActiveRecord::Migration[7.0]
  def change
    create_table :app_calendars do |t|

      t.timestamps
    end
  end
end
