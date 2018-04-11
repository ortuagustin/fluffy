require 'test_helper'

class PostsDislikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
    @owner = users(:teacher)
    @user = users(:student)
  end

  test "unauthorized users cannot dislike posts" do
    post @post.dislike_path
    assert_redirected_to_login
  end

  test "unauthorized users cannot undislike posts" do
    delete @post.dislike_path
    assert_redirected_to_login
  end

  test "authorized users can dislike posts" do
    login_as @user
    post @post.dislike_path
    assert_response :redirect
  end

  test "authorized users can undislike posts" do
    login_as @user
    delete @post.dislike_path
    assert_response :redirect
  end

  test "owner cannot dislike its posts" do
    login_as @owner
    post @post.dislike_path
    assert_response :forbidden
  end

  test "owner cannot undislike its posts" do
    login_as @owner
    delete @post.dislike_path
    assert_response :forbidden
  end

  test "it returns the JSON representation of the post for xhr requests" do
    login_as @user
    post @post.dislike_path, params: { format: 'json' }

    assert_response :success
    assert_equal @post.to_json, response.body
  end
end
