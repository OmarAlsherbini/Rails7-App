require "test_helper"

class TestChildrenControllerTest < ActionDispatch::IntegrationTest
  setup do
    @test_child = test_children(:one)
  end

  test "should get index" do
    get test_children_url
    assert_response :success
  end

  test "should get new" do
    get new_test_child_url
    assert_response :success
  end

  test "should create test_child" do
    assert_difference("TestChild.count") do
      post test_children_url, params: { test_child: { test_parent_id: @test_child.test_parent_id } }
    end

    assert_redirected_to test_child_url(TestChild.last)
  end

  test "should show test_child" do
    get test_child_url(@test_child)
    assert_response :success
  end

  test "should get edit" do
    get edit_test_child_url(@test_child)
    assert_response :success
  end

  test "should update test_child" do
    patch test_child_url(@test_child), params: { test_child: { test_parent_id: @test_child.test_parent_id } }
    assert_redirected_to test_child_url(@test_child)
  end

  test "should destroy test_child" do
    assert_difference("TestChild.count", -1) do
      delete test_child_url(@test_child)
    end

    assert_redirected_to test_children_url
  end
end
