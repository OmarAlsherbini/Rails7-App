require "application_system_test_case"

class MonthAppsTest < ApplicationSystemTestCase
  setup do
    @month_app = month_apps(:one)
  end

  test "visiting the index" do
    visit month_apps_url
    assert_selector "h1", text: "Month apps"
  end

  test "should create month app" do
    visit month_apps_url
    click_on "New month app"

    fill_in "Calendar app", with: @month_app.calendar_app_id
    fill_in "Current year", with: @month_app.current_year
    fill_in "Days", with: @month_app.days
    fill_in "Month", with: @month_app.month
    fill_in "Name", with: @month_app.name
    fill_in "Numspace", with: @month_app.numSpace
    click_on "Create Month app"

    assert_text "Month app was successfully created"
    click_on "Back"
  end

  test "should update Month app" do
    visit month_app_url(@month_app)
    click_on "Edit this month app", match: :first

    fill_in "Calendar app", with: @month_app.calendar_app_id
    fill_in "Current year", with: @month_app.current_year
    fill_in "Days", with: @month_app.days
    fill_in "Month", with: @month_app.month
    fill_in "Name", with: @month_app.name
    fill_in "Numspace", with: @month_app.numSpace
    click_on "Update Month app"

    assert_text "Month app was successfully updated"
    click_on "Back"
  end

  test "should destroy Month app" do
    visit month_app_url(@month_app)
    click_on "Destroy this month app", match: :first

    assert_text "Month app was successfully destroyed"
  end
end
