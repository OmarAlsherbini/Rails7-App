require "test_helper"

class AppYearsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_year = app_years(:one)
  end

  test "should get index" do
    get app_years_url
    assert_response :success
  end

  test "should get new" do
    get new_app_year_url
    assert_response :success
  end

  test "should create app_year" do
    assert_difference("AppYear.count") do
      post app_years_url, params: { app_year: { app_calendar_id: @app_year.app_calendar_id, yr: @app_year.yr } }
    end

    assert_redirected_to app_year_url(AppYear.last)
  end

  test "should show app_year" do
    get app_year_url(@app_year)
    assert_response :success
  end

  test "should get edit" do
    get edit_app_year_url(@app_year)
    assert_response :success
  end

  test "should update app_year" do
    patch app_year_url(@app_year), params: { app_year: { app_calendar_id: @app_year.app_calendar_id, yr: @app_year.yr } }
    assert_redirected_to app_year_url(@app_year)
  end

  test "should destroy app_year" do
    assert_difference("AppYear.count", -1) do
      delete app_year_url(@app_year)
    end

    assert_redirected_to app_years_url
  end
end
