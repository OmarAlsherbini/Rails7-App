require "application_system_test_case"

class TestParentsTest < ApplicationSystemTestCase
  setup do
    @test_parent = test_parents(:one)
  end

  test "visiting the index" do
    visit test_parents_url
    assert_selector "h1", text: "Test parents"
  end

  test "should create test parent" do
    visit test_parents_url
    click_on "New test parent"

    click_on "Create Test parent"

    assert_text "Test parent was successfully created"
    click_on "Back"
  end

  test "should update Test parent" do
    visit test_parent_url(@test_parent)
    click_on "Edit this test parent", match: :first

    click_on "Update Test parent"

    assert_text "Test parent was successfully updated"
    click_on "Back"
  end

  test "should destroy Test parent" do
    visit test_parent_url(@test_parent)
    click_on "Destroy this test parent", match: :first

    assert_text "Test parent was successfully destroyed"
  end
end
