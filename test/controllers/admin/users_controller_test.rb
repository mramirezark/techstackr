require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @admin = User.create!(username: "admin_test_#{SecureRandom.hex(4)}", password: "password123", password_confirmation: "password123", role: "admin")
    post login_url, params: { username: @admin.username, password: "password123" }
  end

  test "should get index" do
    get admin_users_url
    assert_response :success
  end

  test "should get modal_new" do
    get modal_new_admin_users_url
    assert_response :success
  end

  test "should get create" do
    post admin_users_url, params: { user: { username: "newuser", password: "password123", password_confirmation: "password123", role: "user" } }
    assert_response :redirect
  end

  test "should get modal_edit" do
    user = User.create!(username: "edituser", password: "password123", password_confirmation: "password123", role: "user")
    get modal_edit_admin_user_url(user)
    assert_response :success
  end

  test "should get update" do
    user = User.create!(username: "updateuser", password: "password123", password_confirmation: "password123", role: "user")
    patch admin_user_url(user), params: { user: { username: "updateduser" } }
    assert_response :redirect
  end

  test "should get destroy" do
    user = User.create!(username: "deleteuser", password: "password123", password_confirmation: "password123", role: "user")
    delete admin_user_url(user)
    assert_response :redirect
  end
end
