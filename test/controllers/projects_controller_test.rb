require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(username: "projects_test_user_#{SecureRandom.hex(4)}", password: "password123", password_confirmation: "password123", role: "user")
    post login_url, params: { username: @user.username, password: "password123" }
  end

  test "should get index" do
    get projects_url
    assert_response :success
  end

  test "should get modal_new" do
    get modal_new_projects_url
    assert_response :success
  end

  test "should get create" do
    post projects_url, params: { project: { title: "Test Project", industry: "Technology", project_type: "web_application", description: "Test description" } }
    assert_response :redirect
  end
end
