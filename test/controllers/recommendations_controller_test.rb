require "test_helper"

class RecommendationsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get recommendations_create_url
    assert_response :success
  end

  test "should get show" do
    get recommendations_show_url
    assert_response :success
  end
end
