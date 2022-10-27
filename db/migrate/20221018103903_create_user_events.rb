class CreateUserEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :user_events do |t|
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :user_first_name
      t.string :user_last_name
      t.string :user_phone_number
      t.string :user_physical_address
      t.string :user_lat_long
      t.float :user_performance

      t.timestamps
    end
  end
end
