require "test_helper"

class RecommendationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(username: "recommendations_test_user_#{SecureRandom.hex(4)}", password: "password123", password_confirmation: "password123", role: "user")
    post login_url, params: { username: @user.username, password: "password123" }
  end

  test "should get create" do
    project = Project.create!(title: "Test Project", industry: "Technology", project_type: "web_application", description: "Test description", user: @user)
    post project_recommendation_url(project)
    assert_response :redirect
  end
end
