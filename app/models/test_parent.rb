class TestParent < ApplicationRecord
    after_create :create_children
    private
    def create_children
        child_one = TestChild.create(test_parent_id: self.id)
        child_two = TestChild.create(test_parent_id: self.id)
        self.child_one = child_one.id
        self.child_two = child_two.id
        self.save
    end
end
