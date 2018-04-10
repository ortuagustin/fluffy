require 'test_helper'

class RepliesDisdislikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:foo_course)
    @post = posts(:one)
    @reply = replies(:reply_for_post_one)
    @owner = users(:teacher)
    @user = users(:student)
  end

  test "unauthorized users cannot dislike replies" do
    post dislike_course_post_reply_path(@course, @post, @reply)
    assert_redirected_to '/users/login'
  end

  test "unauthorized users cannot undislike replies" do
    delete dislike_course_post_reply_path(@course, @post, @reply)
    assert_redirected_to '/users/login'
  end

  test "authorized users can dislike replies" do
    login_as @user
    post dislike_course_post_reply_path(@course, @post, @reply)
    assert_response :redirect
  end

  test "authorized users can undislike replies" do
    login_as @user
    delete dislike_course_post_reply_path(@course, @post, @reply)
    assert_response :redirect
  end

  test "owner cannot dislike its replies" do
    login_as @owner
    post dislike_course_post_reply_path(@course, @post, @reply)
    assert_response :forbidden
  end

  test "owner cannot undislike its replies" do
    login_as @owner
    delete dislike_course_post_reply_path(@course, @post, @reply)
    assert_response :forbidden
  end

  test "it returns the JSON representation of the reply for xhr requests" do
    login_as @user
    post dislike_course_post_reply_path(@course, @post, @reply, format: 'json')

    assert_response :success
    assert_equal @reply.to_json, response.body
  end
end
