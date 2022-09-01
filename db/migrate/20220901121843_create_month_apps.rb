class CreateMonthApps < ActiveRecord::Migration[7.0]
  def change
    create_table :month_apps do |t|
      t.references :calendar_app, null: false, foreign_key: true
      t.string :name
      t.integer :month
      t.integer :days
      t.integer :numSpace
      t.integer :current_year

      t.timestamps
    end
  end
end
