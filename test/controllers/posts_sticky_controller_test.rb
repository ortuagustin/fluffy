require 'test_helper'

class PostsStickyControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
    @user = users(:teacher)
    @admin = users(:admin)
  end

  test "unauthenticated users cannot set posts as sticky" do
    post @post.pin_path
    assert_redirected_to_login
  end

  test "unauthenticated users cannot unset posts as sticky" do
    delete @post.pin_path
    assert_redirected_to_login
  end

  test "regular users cannot set posts as sticky" do
    login_as @user
    post @post.pin_path
    assert_response :forbidden
  end

  test "regular users cannot unset posts as sticky" do
    login_as @user
    delete @post.pin_path
    assert_response :forbidden
  end

  test "admins can set posts as sticky" do
    login_as @admin
    post @post.pin_path
    assert_response :redirect
  end

  test "admins can unset posts as sticky" do
    login_as @admin
    delete @post.pin_path
    assert_response :redirect
  end
end
