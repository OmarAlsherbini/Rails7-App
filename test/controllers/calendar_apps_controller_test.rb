require "test_helper"

class CalendarAppsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @calendar_app = calendar_apps(:one)
  end

  test "should get index" do
    get calendar_apps_url
    assert_response :success
  end

  test "should get new" do
    get new_calendar_app_url
    assert_response :success
  end

  test "should create calendar_app" do
    assert_difference("CalendarApp.count") do
      post calendar_apps_url, params: { calendar_app: {  } }
    end

    assert_redirected_to calendar_app_url(CalendarApp.last)
  end

  test "should show calendar_app" do
    get calendar_app_url(@calendar_app)
    assert_response :success
  end

  test "should get edit" do
    get edit_calendar_app_url(@calendar_app)
    assert_response :success
  end

  test "should update calendar_app" do
    patch calendar_app_url(@calendar_app), params: { calendar_app: {  } }
    assert_redirected_to calendar_app_url(@calendar_app)
  end

  test "should destroy calendar_app" do
    assert_difference("CalendarApp.count", -1) do
      delete calendar_app_url(@calendar_app)
    end

    assert_redirected_to calendar_apps_url
  end
end
