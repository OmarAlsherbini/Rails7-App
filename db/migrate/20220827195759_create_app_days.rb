class CreateAppDays < ActiveRecord::Migration[7.0]
  def change
    create_table :app_days do |t|
      t.references :app_calendar, null: false, foreign_key: true
      t.references :app_year, null: false, foreign_key: true
      t.references :app_month, null: false, foreign_key: true
      t.integer :day
      t.string :name

      t.timestamps
    end
  end
end
