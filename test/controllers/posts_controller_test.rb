require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:foo_course)
    @post = posts(:one)
    @teacher = users(:teacher)
  end

  test "unauthorized users cannot see posts" do
    get @course.forum_path
    assert_redirected_to_login
  end

  test "authorized users can see posts" do
    login_as @teacher
    get @course.forum_path
    assert_response :success
  end

  test "unauthorized users cannot create posts" do
    assert_no_difference "Post.count" do
      post @course.forum_path, params: { post: post_params }
      assert_redirected_to_login
    end
  end

  test "authorized users can create posts" do
    login_as @teacher

    assert_difference('Post.count') do
      post @course.forum_path, params: { post: post_params }
      assert_response :redirect
    end
  end

  test "only the post owner can edit a post" do
    login_as users(:student)
    patch @post.path, params: { post: post_params }
    assert_response :forbidden
  end

  test "a post can be edited by its owner" do
    login_as @teacher
    patch @post.path, params: { post: edit_post_params, format: 'json' }
    assert_response :success

    @post.reload
    assert_equal 'changed title', @post.title
    assert_equal 'changed body', @post.body
  end
private
  def post_params
    { title: 'test', body: 'test', user_id: @teacher.id, course_id: @course.id }
  end

  def edit_post_params
    { title: 'changed title', body: 'changed body' }
  end
end
