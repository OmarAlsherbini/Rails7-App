require "application_system_test_case"

class TestChildrenTest < ApplicationSystemTestCase
  setup do
    @test_child = test_children(:one)
  end

  test "visiting the index" do
    visit test_children_url
    assert_selector "h1", text: "Test children"
  end

  test "should create test child" do
    visit test_children_url
    click_on "New test child"

    fill_in "Test parent", with: @test_child.test_parent_id
    click_on "Create Test child"

    assert_text "Test child was successfully created"
    click_on "Back"
  end

  test "should update Test child" do
    visit test_child_url(@test_child)
    click_on "Edit this test child", match: :first

    fill_in "Test parent", with: @test_child.test_parent_id
    click_on "Update Test child"

    assert_text "Test child was successfully updated"
    click_on "Back"
  end

  test "should destroy Test child" do
    visit test_child_url(@test_child)
    click_on "Destroy this test child", match: :first

    assert_text "Test child was successfully destroyed"
  end
end
