require "application_system_test_case"

class CalendarAppsTest < ApplicationSystemTestCase
  setup do
    @calendar_app = calendar_apps(:one)
  end

  test "visiting the index" do
    visit calendar_apps_url
    assert_selector "h1", text: "Calendar apps"
  end

  test "should create calendar app" do
    visit calendar_apps_url
    click_on "New calendar app"

    click_on "Create Calendar app"

    assert_text "Calendar app was successfully created"
    click_on "Back"
  end

  test "should update Calendar app" do
    visit calendar_app_url(@calendar_app)
    click_on "Edit this calendar app", match: :first

    click_on "Update Calendar app"

    assert_text "Calendar app was successfully updated"
    click_on "Back"
  end

  test "should destroy Calendar app" do
    visit calendar_app_url(@calendar_app)
    click_on "Destroy this calendar app", match: :first

    assert_text "Calendar app was successfully destroyed"
  end
end
