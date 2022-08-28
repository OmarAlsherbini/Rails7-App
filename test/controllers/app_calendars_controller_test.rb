require "test_helper"

class AppCalendarsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_calendar = app_calendars(:one)
  end

  test "should get index" do
    get app_calendars_url
    assert_response :success
  end

  test "should get new" do
    get new_app_calendar_url
    assert_response :success
  end

  test "should create app_calendar" do
    assert_difference("AppCalendar.count") do
      post app_calendars_url, params: { app_calendar: {  } }
    end

    assert_redirected_to app_calendar_url(AppCalendar.last)
  end

  test "should show app_calendar" do
    get app_calendar_url(@app_calendar)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_calendar_url(@app_calendar)
    assert_response :success
  end

  test "should update app_calendar" do
    patch app_calendar_url(@app_calendar), params: { app_calendar: {  } }
    assert_redirected_to app_calendar_url(@app_calendar)
  end

  test "should destroy app_calendar" do
    assert_difference("AppCalendar.count", -1) do
      delete app_calendar_url(@app_calendar)
    end

    assert_redirected_to app_calendars_url
  end
end
