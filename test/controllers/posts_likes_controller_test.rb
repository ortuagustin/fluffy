require 'test_helper'

class PostsLikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:foo_course)
    @post = posts(:one)
    @owner = users(:teacher)
    @user = users(:student)
  end

  test "unauthorized users cannot like posts" do
    post like_course_post_path(@course, @post)
    assert_redirected_to_login
  end

  test "unauthorized users cannot unlike posts" do
    delete like_course_post_path(@course, @post)
    assert_redirected_to_login
  end

  test "authorized users can like posts" do
    login_as @user
    post like_course_post_path(@course, @post)
    assert_response :redirect
  end

  test "authorized users can unlike posts" do
    login_as @user
    delete like_course_post_path(@course, @post)
    assert_response :redirect
  end

  test "owner cannot like its posts" do
    login_as @owner
    post like_course_post_path(@course, @post)
    assert_response :forbidden
  end

  test "owner cannot unlike its posts" do
    login_as @owner
    delete like_course_post_path(@course, @post)
    assert_response :forbidden
  end

  test "it returns the JSON representation of the post for xhr requests" do
    login_as @user
    post like_course_post_path(@course, @post, format: 'json')

    assert_response :success
    assert_equal @post.to_json, response.body
  end
end
