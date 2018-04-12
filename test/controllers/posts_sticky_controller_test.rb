require 'test_helper'

class PostsStickyControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
    @user = users(:teacher)
  end

  test "unauthorized users cannot set posts as sticky" do
    post @post.pin_path
    assert_redirected_to_login
  end

  test "unauthorized users cannot unset posts as sticky" do
    delete @post.pin_path
    assert_redirected_to_login
  end

  test "authorized users can set posts as sticky" do
    login_as @user
    post @post.pin_path
    assert_response :redirect
  end

  test "authorized users can unset posts as sticky" do
    login_as @user
    delete @post.pin_path
    assert_response :redirect
  end
end
