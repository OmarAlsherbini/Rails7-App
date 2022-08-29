require "test_helper"

class TestParentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @test_parent = test_parents(:one)
  end

  test "should get index" do
    get test_parents_url
    assert_response :success
  end

  test "should get new" do
    get new_test_parent_url
    assert_response :success
  end

  test "should create test_parent" do
    assert_difference("TestParent.count") do
      post test_parents_url, params: { test_parent: {  } }
    end

    assert_redirected_to test_parent_url(TestParent.last)
  end

  test "should show test_parent" do
    get test_parent_url(@test_parent)
    assert_response :success
  end

  test "should get edit" do
    get edit_test_parent_url(@test_parent)
    assert_response :success
  end

  test "should update test_parent" do
    patch test_parent_url(@test_parent), params: { test_parent: {  } }
    assert_redirected_to test_parent_url(@test_parent)
  end

  test "should destroy test_parent" do
    assert_difference("TestParent.count", -1) do
      delete test_parent_url(@test_parent)
    end

    assert_redirected_to test_parents_url
  end
end
