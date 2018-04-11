require 'test_helper'

class PostsSubscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
    @user = users(:student)
    @course = @post.course
  end

  test "unauthorized users cannot subscribe to posts" do
    post @post.subscribe_path
    assert_redirected_to_login
  end

  test "unauthorized users cannot unsubscribe from posts" do
    delete @post.subscribe_path
    assert_redirected_to_login
  end

  test "authorized users can subscribe to posts" do
    login_as @user
    post @post.subscribe_path
    assert_redirected_to course_post_path(@course, @post)
  end

  test "authorized users can unsubscribe from posts" do
    login_as @user
    delete @post.subscribe_path
    assert_redirected_to course_post_path(@course, @post)
  end
end
