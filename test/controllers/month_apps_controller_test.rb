require "test_helper"

class MonthAppsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @month_app = month_apps(:one)
  end

  test "should get index" do
    get month_apps_url
    assert_response :success
  end

  test "should get new" do
    get new_month_app_url
    assert_response :success
  end

  test "should create month_app" do
    assert_difference("MonthApp.count") do
      post month_apps_url, params: { month_app: { calendar_app_id: @month_app.calendar_app_id, current_year: @month_app.current_year, days: @month_app.days, month: @month_app.month, name: @month_app.name, numSpace: @month_app.numSpace } }
    end

    assert_redirected_to month_app_url(MonthApp.last)
  end

  test "should show month_app" do
    get month_app_url(@month_app)
    assert_response :success
  end

  test "should get edit" do
    get edit_month_app_url(@month_app)
    assert_response :success
  end

  test "should update month_app" do
    patch month_app_url(@month_app), params: { month_app: { calendar_app_id: @month_app.calendar_app_id, current_year: @month_app.current_year, days: @month_app.days, month: @month_app.month, name: @month_app.name, numSpace: @month_app.numSpace } }
    assert_redirected_to month_app_url(@month_app)
  end

  test "should destroy month_app" do
    assert_difference("MonthApp.count", -1) do
      delete month_app_url(@month_app)
    end

    assert_redirected_to month_apps_url
  end
end
