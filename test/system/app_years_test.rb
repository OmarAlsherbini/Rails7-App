require "application_system_test_case"

class AppYearsTest < ApplicationSystemTestCase
  setup do
    @app_year = app_years(:one)
  end

  test "visiting the index" do
    visit app_years_url
    assert_selector "h1", text: "App years"
  end

  test "should create app year" do
    visit app_years_url
    click_on "New app year"

    fill_in "App calendar", with: @app_year.app_calendar_id
    fill_in "Yr", with: @app_year.yr
    click_on "Create App year"

    assert_text "App year was successfully created"
    click_on "Back"
  end

  test "should update App year" do
    visit app_year_url(@app_year)
    click_on "Edit this app year", match: :first

    fill_in "App calendar", with: @app_year.app_calendar_id
    fill_in "Yr", with: @app_year.yr
    click_on "Update App year"

    assert_text "App year was successfully updated"
    click_on "Back"
  end

  test "should destroy App year" do
    visit app_year_url(@app_year)
    click_on "Destroy this app year", match: :first

    assert_text "App year was successfully destroyed"
  end
end
