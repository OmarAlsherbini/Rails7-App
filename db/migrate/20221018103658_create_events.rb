class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :month_app, null: false, foreign_key: true
      t.string :name
      t.boolean :all_day, default: false, null: false
      t.boolean :overwritable, default: false, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.integer :event_type, null: false
      t.string :event_details
      t.integer :event_value

      t.timestamps
    end
  end
end
