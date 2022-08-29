class CreateTestParents < ActiveRecord::Migration[7.0]
  def change
    create_table :test_parents do |t|

      t.timestamps
    end
  end
end
