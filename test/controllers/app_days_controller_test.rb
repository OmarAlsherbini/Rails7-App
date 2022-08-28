require "test_helper"

class AppDaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_day = app_days(:one)
  end

  test "should get index" do
    get app_days_url
    assert_response :success
  end

  test "should get new" do
    get new_app_day_url
    assert_response :success
  end

  test "should create app_day" do
    assert_difference("AppDay.count") do
      post app_days_url, params: { app_day: { app_calendar_id: @app_day.app_calendar_id, app_month_id: @app_day.app_month_id, app_year_id: @app_day.app_year_id, day: @app_day.day, name: @app_day.name } }
    end

    assert_redirected_to app_day_url(AppDay.last)
  end

  test "should show app_day" do
    get app_day_url(@app_day)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_day_url(@app_day)
    assert_response :success
  end

  test "should update app_day" do
    patch app_day_url(@app_day), params: { app_day: { app_calendar_id: @app_day.app_calendar_id, app_month_id: @app_day.app_month_id, app_year_id: @app_day.app_year_id, day: @app_day.day, name: @app_day.name } }
    assert_redirected_to app_day_url(@app_day)
  end

  test "should destroy app_day" do
    assert_difference("AppDay.count", -1) do
      delete app_day_url(@app_day)
    end

    assert_redirected_to app_days_url
  end
end
