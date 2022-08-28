require "application_system_test_case"

class AppCalendarsTest < ApplicationSystemTestCase
  setup do
    @app_calendar = app_calendars(:one)
  end

  test "visiting the index" do
    visit app_calendars_url
    assert_selector "h1", text: "App calendars"
  end

  test "should create app calendar" do
    visit app_calendars_url
    click_on "New app calendar"

    click_on "Create App calendar"

    assert_text "App calendar was successfully created"
    click_on "Back"
  end

  test "should update App calendar" do
    visit app_calendar_url(@app_calendar)
    click_on "Edit this app calendar", match: :first

    click_on "Update App calendar"

    assert_text "App calendar was successfully updated"
    click_on "Back"
  end

  test "should destroy App calendar" do
    visit app_calendar_url(@app_calendar)
    click_on "Destroy this app calendar", match: :first

    assert_text "App calendar was successfully destroyed"
  end
end
