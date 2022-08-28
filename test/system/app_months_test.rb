require "application_system_test_case"

class AppMonthsTest < ApplicationSystemTestCase
  setup do
    @app_month = app_months(:one)
  end

  test "visiting the index" do
    visit app_months_url
    assert_selector "h1", text: "App months"
  end

  test "should create app month" do
    visit app_months_url
    click_on "New app month"

    fill_in "App calendar", with: @app_month.app_calendar_id
    fill_in "App year", with: @app_month.app_year_id
    fill_in "Days", with: @app_month.days
    fill_in "Month", with: @app_month.month
    fill_in "Name", with: @app_month.name
    fill_in "Numspaces", with: @app_month.numSpaces
    click_on "Create App month"

    assert_text "App month was successfully created"
    click_on "Back"
  end

  test "should update App month" do
    visit app_month_url(@app_month)
    click_on "Edit this app month", match: :first

    fill_in "App calendar", with: @app_month.app_calendar_id
    fill_in "App year", with: @app_month.app_year_id
    fill_in "Days", with: @app_month.days
    fill_in "Month", with: @app_month.month
    fill_in "Name", with: @app_month.name
    fill_in "Numspaces", with: @app_month.numSpaces
    click_on "Update App month"

    assert_text "App month was successfully updated"
    click_on "Back"
  end

  test "should destroy App month" do
    visit app_month_url(@app_month)
    click_on "Destroy this app month", match: :first

    assert_text "App month was successfully destroyed"
  end
end
