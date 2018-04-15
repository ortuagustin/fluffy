require 'test_helper'

class PostsLikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
    @owner = users(:teacher)
    @user = users(:student)
  end

  test "unauthenticated users cannot like posts" do
    post @post.like_path
    assert_redirected_to_login
  end

  test "unauthenticated users cannot unlike posts" do
    delete @post.like_path
    assert_redirected_to_login
  end

  test "authenticated users can like posts" do
    login_as @user
    post @post.like_path
    assert_response :redirect
  end

  test "authenticated users can unlike posts" do
    login_as @user
    delete @post.like_path
    assert_response :redirect
  end

  test "owner cannot like its posts" do
    login_as @owner
    post @post.like_path
    assert_response :forbidden
  end

  test "owner cannot unlike its posts" do
    login_as @owner
    delete @post.like_path
    assert_response :forbidden
  end

  test "it returns the JSON representation of the post for xhr requests" do
    login_as @user
    post @post.like_path, params: { format: 'json' }

    assert_response :success
    assert_equal @post.to_json, response.body
  end
end
