class CreateAppMonths < ActiveRecord::Migration[7.0]
  def change
    create_table :app_months do |t|
      t.references :app_calendar, null: false, foreign_key: true
      t.references :app_year, null: false, foreign_key: true
      t.integer :days
      t.integer :numSpaces
      t.string :name
      t.integer :month

      t.timestamps
    end
  end
end
