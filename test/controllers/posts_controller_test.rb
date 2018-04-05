require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:current_course)
    @post = posts(:one)
    @user = users(:teacher)
  end

  test "unauthorized users cannot see posts" do
    get course_posts_path(@course)
    assert_redirected_to '/users/login'
  end

  test "authorized users can see posts" do
    login_as @user
    get course_posts_path(@course)
    assert_response :success
  end

  test "unauthorized users cannot create posts" do
    assert_no_difference "Post.count" do
      post course_posts_path(@course), params: { post: post_params }
      assert_redirected_to '/users/login'
    end
  end

  test "authorized users can create posts" do
    login_as @user

    assert_difference('Post.count') do
      post course_posts_path(@course), params: { post: post_params }
      assert_response :redirect
    end
  end
private
  def post_params
    { title: 'test', body: 'test', user_id: @user.id }
  end
end
