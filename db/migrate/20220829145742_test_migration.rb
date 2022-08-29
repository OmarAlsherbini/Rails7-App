class TestMigration < ActiveRecord::Migration[7.0]
  def change
    add_column :test_parents, :child_one, :bigint
    add_column :test_parents, :child_two, :bigint
    add_foreign_key :test_parents, :test_children, column: :child_one
    add_foreign_key :test_parents, :test_children, column: :child_two
  end
end
