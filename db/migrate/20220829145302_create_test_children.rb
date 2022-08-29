class CreateTestChildren < ActiveRecord::Migration[7.0]
  def change
    create_table :test_children do |t|
      t.references :test_parent, null: false, foreign_key: true

      t.timestamps
    end
  end
end
