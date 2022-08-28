require "application_system_test_case"

class AppDaysTest < ApplicationSystemTestCase
  setup do
    @app_day = app_days(:one)
  end

  test "visiting the index" do
    visit app_days_url
    assert_selector "h1", text: "App days"
  end

  test "should create app day" do
    visit app_days_url
    click_on "New app day"

    fill_in "App calendar", with: @app_day.app_calendar_id
    fill_in "App month", with: @app_day.app_month_id
    fill_in "App year", with: @app_day.app_year_id
    fill_in "Day", with: @app_day.day
    fill_in "Name", with: @app_day.name
    click_on "Create App day"

    assert_text "App day was successfully created"
    click_on "Back"
  end

  test "should update App day" do
    visit app_day_url(@app_day)
    click_on "Edit this app day", match: :first

    fill_in "App calendar", with: @app_day.app_calendar_id
    fill_in "App month", with: @app_day.app_month_id
    fill_in "App year", with: @app_day.app_year_id
    fill_in "Day", with: @app_day.day
    fill_in "Name", with: @app_day.name
    click_on "Update App day"

    assert_text "App day was successfully updated"
    click_on "Back"
  end

  test "should destroy App day" do
    visit app_day_url(@app_day)
    click_on "Destroy this app day", match: :first

    assert_text "App day was successfully destroyed"
  end
end
