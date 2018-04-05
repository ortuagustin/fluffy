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
end
