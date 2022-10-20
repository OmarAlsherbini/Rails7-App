class AddFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :mailing_address, :string
    add_column :users, :phone_number, :string
    add_column :users, :physical_address, :string
    add_column :users, :lat_long, :string
    add_column :users, :performance, :float
  end
end
