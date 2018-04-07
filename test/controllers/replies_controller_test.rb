require 'test_helper'

class RepliesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:current_course)
    @post = posts(:one)
    @user = users(:teacher)
  end

  test "unauthorized users cannot reply to posts" do
    assert_no_difference "Reply.count" do
      post course_post_replies_path(@course, @post), params: { reply: reply_params }
      assert_redirected_to '/users/login'

      post course_post_replies_path(@course, @post), params: { reply: reply_params, format: 'json' }
      assert_response :unauthorized
    end
  end

  test "authorized users can reply to posts" do
    login_as @user

    assert_difference('Reply.count') do
      post course_post_replies_path(@course, @post), params: { reply: reply_params, format: 'json' }
      assert_response :success
    end
  end
private
  def reply_params
    { body: 'test', post_id: @post.id, user_id: @user.id }
  end
end
