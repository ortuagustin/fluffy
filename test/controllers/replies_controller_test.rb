require 'test_helper'

class RepliesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:current_course)
    @user = users(:teacher)
    @post = posts(:two)
    @reply = replies(:two)
  end

  test "unauthorized users cannot reply to posts" do
    assert_no_difference "Reply.count" do
      post course_post_replies_path(@course, @post), params: { reply: reply_params }
      assert_redirected_to_login

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

  test "only the owner can edit the reply" do
    login_as @user
    assert_not_equal @user, @reply.user
    patch course_post_reply_path(@course, @post, @reply), params: { reply: edit_reply_params, format: 'json' }
    assert_response :forbidden
  end

  test "a reply can be edited by its owner" do
    login_as @reply.user
    patch course_post_reply_path(@course, @post, @reply), params: { reply: edit_reply_params, format: 'json' }
    assert_response :success

    @reply.reload
    assert_equal 'changed body', @reply.body
  end
private
  def reply_params
    { body: 'test', post_id: @post.id, user_id: @user.id }
  end

  def edit_reply_params
    { body: 'changed body' }
  end
end
