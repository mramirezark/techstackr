require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new (signup page)" do
    get signup_path
    assert_response :success
  end

  test "should create user with valid params" do
    assert_difference("User.count") do
      post signup_path, params: {
        user: { username: "newuser", password: "password123", password_confirmation: "password123" }
      }
    end
    assert_redirected_to root_path
    assert session[:user_id].present?
  end

  test "should not create user with invalid params" do
    assert_no_difference("User.count") do
      post signup_path, params: {
        user: { username: "", password: "pass", password_confirmation: "pass" }
      }
    end
    assert_response :unprocessable_entity
  end
end
