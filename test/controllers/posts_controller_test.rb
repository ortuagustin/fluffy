require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:foo_course)
    @post = posts(:one)
    @teacher = users(:teacher)
  end

  test "unauthorized users cannot see posts" do
    get course_posts_path(@course)
    assert_redirected_to '/users/login'
  end

  test "authorized users can see posts" do
    login_as @teacher
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
    login_as @teacher

    assert_difference('Post.count') do
      post course_posts_path(@course), params: { post: post_params }
      assert_response :redirect
    end
  end

  test "only the post owner can edit a post" do
    login_as users(:student)
    patch course_post_path(@course, @post), params: { post: post_params }
    assert_response :unauthorized
  end
private
  def post_params
    { title: 'test', body: 'test', user_id: @teacher.id }
  end
end
