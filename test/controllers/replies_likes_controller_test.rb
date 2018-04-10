require 'test_helper'

class RepliesLikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:foo_course)
    @post = posts(:one)
    @reply = replies(:reply_for_post_one)
    @owner = users(:teacher)
    @user = users(:student)
  end

  test "unauthorized users cannot like replies" do
    post like_course_post_reply_path(@course, @post, @reply)
    assert_redirected_to '/users/login'
  end

  test "unauthorized users cannot unlike replies" do
    delete like_course_post_reply_path(@course, @post, @reply)
    assert_redirected_to '/users/login'
  end

  test "authorized users can like replies" do
    login_as @user
    post like_course_post_reply_path(@course, @post, @reply)
    assert_response :redirect
  end

  test "authorized users can unlike replies" do
    login_as @user
    delete like_course_post_reply_path(@course, @post, @reply)
    assert_response :redirect
  end

  test "owner cannot like its replies" do
    login_as @owner
    post like_course_post_reply_path(@course, @post, @reply)
    assert_response :forbidden
  end

  test "owner cannot unlike its replies" do
    login_as @owner
    delete like_course_post_reply_path(@course, @post, @reply)
    assert_response :forbidden
  end

  test "it returns the JSON representation of the reply for xhr requests" do
    login_as @user
    post like_course_post_reply_path(@course, @post, @reply, format: 'json')

    assert_response :success
    assert_equal @reply.to_json, response.body
  end
end
