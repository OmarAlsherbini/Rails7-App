class CreateAppYears < ActiveRecord::Migration[7.0]
  def change
    create_table :app_years do |t|
      t.references :app_calendar, null: false, foreign_key: true
      t.integer :yr

      t.timestamps
    end
  end
end
