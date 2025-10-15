require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new (login page)" do
    get login_path
    assert_response :success
  end

  test "should create session with valid credentials" do
    post login_path, params: { username: "testuser", password: "password123" }
    assert_redirected_to root_path
    assert session[:user_id].present?
  end

  test "should not create session with invalid credentials" do
    post login_path, params: { username: "testuser", password: "wrong" }
    assert_response :unprocessable_entity
    assert_nil session[:user_id]
  end

  test "should destroy session on logout" do
    post login_path, params: { username: "testuser", password: "password123" }
    delete logout_path
    assert_redirected_to root_path
    assert_nil session[:user_id]
  end
end
