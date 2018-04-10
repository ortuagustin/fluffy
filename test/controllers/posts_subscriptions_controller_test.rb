require 'test_helper'

class PostsSubscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:one)
    @user = users(:student)
    @course = @post.course
  end

  test "unauthorized users cannot subscribe to posts" do
    post subscribe_post_path(@post)
    assert_redirected_to '/users/login'
  end

  test "unauthorized users cannot unsubscribe from posts" do
    delete subscribe_post_path(@post)
    assert_redirected_to '/users/login'
  end

  test "authorized users can subscribe to posts" do
    login_as @user
    post subscribe_post_path(@post)
    assert_redirected_to course_post_path(@course, @post)
  end

  test "authorized users can unsubscribe from posts" do
    login_as @user
    delete subscribe_post_path(@post)
    assert_redirected_to course_post_path(@course, @post)
  end
end
