require 'test_helper'

class RepliesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:teacher)
    @admin = users(:admin)
    @post = posts(:two)
    @reply = replies(:two)
  end

  test "unauthenticated users cannot reply to posts" do
    assert_no_difference "Reply.count" do
      post @post.replies_path, params: { reply: reply_params }
      assert_redirected_to_login

      post @post.replies_path, params: { reply: reply_params, format: 'json' }
      assert_response :unauthorized
    end
  end

  test "authenticated users can reply to posts" do
    login_as @user

    assert_difference('Reply.count') do
      post @post.replies_path, params: { reply: reply_params, format: 'json' }
      assert_response :success
    end
  end

  test "unauthorized cannot edit the reply" do
    login_as @user
    assert_not_equal @user, @reply.user
    patch @reply.path, params: { reply: edit_reply_params, format: 'json' }
    assert_response :forbidden
  end

  test "the reply owner is authorized to edit the replay" do
    login_as @reply.user
    patch @reply.path, params: { reply: edit_reply_params, format: 'json' }
    assert_response :success

    @reply.reload
    assert_equal 'changed body', @reply.body
  end

  test "admins are authorized to edit all replies" do
    login_as @admin
    assert_not_equal @admin, @reply.user
    assert @admin.role? :admin
    patch @reply.path, params: { reply: edit_reply_params, format: 'json' }
    assert_response :success

    @reply.reload
    assert_equal 'changed body', @reply.body
    assert_not_equal @admin.id, @reply.user.id
  end
private
  def reply_params
    { body: 'test', post_id: @post.id, user_id: @user.id }
  end

  def edit_reply_params
    { body: 'changed body' }
  end
end
