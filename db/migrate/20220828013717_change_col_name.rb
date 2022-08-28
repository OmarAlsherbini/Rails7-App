class ChangeColName < ActiveRecord::Migration[7.0]
  def change
    rename_column :app_months, :numSpaces, :numSpace
  end
end
