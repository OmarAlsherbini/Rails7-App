require "test_helper"

class AppMonthsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_month = app_months(:one)
  end

  test "should get index" do
    get app_months_url
    assert_response :success
  end

  test "should get new" do
    get new_app_month_url
    assert_response :success
  end

  test "should create app_month" do
    assert_difference("AppMonth.count") do
      post app_months_url, params: { app_month: { app_calendar_id: @app_month.app_calendar_id, app_year_id: @app_month.app_year_id, days: @app_month.days, month: @app_month.month, name: @app_month.name, numSpaces: @app_month.numSpaces } }
    end

    assert_redirected_to app_month_url(AppMonth.last)
  end

  test "should show app_month" do
    get app_month_url(@app_month)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_month_url(@app_month)
    assert_response :success
  end

  test "should update app_month" do
    patch app_month_url(@app_month), params: { app_month: { app_calendar_id: @app_month.app_calendar_id, app_year_id: @app_month.app_year_id, days: @app_month.days, month: @app_month.month, name: @app_month.name, numSpaces: @app_month.numSpaces } }
    assert_redirected_to app_month_url(@app_month)
  end

  test "should destroy app_month" do
    assert_difference("AppMonth.count", -1) do
      delete app_month_url(@app_month)
    end

    assert_redirected_to app_months_url
  end
end
