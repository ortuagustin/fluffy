require 'test_helper'

class PostsDisdislikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:foo_course)
    @post = posts(:one)
    @owner = users(:teacher)
    @user = users(:student)
  end

  test "unauthorized users cannot dislike posts" do
    post dislike_course_post_path(@course, @post)
    assert_redirected_to '/users/login'
  end

  test "unauthorized users cannot undislike posts" do
    delete dislike_course_post_path(@course, @post)
    assert_redirected_to '/users/login'
  end

  test "authorized users can dislike posts" do
    login_as @user
    post dislike_course_post_path(@course, @post)
    assert_response :redirect
  end

  test "authorized users can undislike posts" do
    login_as @user
    delete dislike_course_post_path(@course, @post)
    assert_response :redirect
  end

  test "owner cannot dislike its posts" do
    login_as @owner
    post dislike_course_post_path(@course, @post)
    assert_response :forbidden
  end

  test "owner cannot undislike its posts" do
    login_as @owner
    delete dislike_course_post_path(@course, @post)
    assert_response :forbidden
  end

  test "it returns the JSON representation of the post for xhr requests" do
    login_as @user
    post dislike_course_post_path(@course, @post, format: 'json')

    assert_response :success
    assert_equal @post.to_json, response.body
  end
end
