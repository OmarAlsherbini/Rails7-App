require "test_helper"

class SetupProofControllerTest < ActionDispatch::IntegrationTest
  test "should get psql_test" do
    get setup_proof_psql_test_url
    assert_response :success
  end

  test "should get redis_test" do
    get setup_proof_redis_test_url
    assert_response :success
  end

  test "should get ruby_test" do
    get setup_proof_ruby_test_url
    assert_response :success
  end

  test "should get turbo_test" do
    get setup_proof_turbo_test_url
    assert_response :success
  end

  test "should get stimulus_test" do
    get setup_proof_stimulus_test_url
    assert_response :success
  end

  test "should get tailwind_test" do
    get setup_proof_tailwind_test_url
    assert_response :success
  end
end
