require 'test_helper'

class BestRepliesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reply = replies(:two)
    @post_owner = @reply.post.user
  end

  test "unauthorized users cannot select best replies" do
    post select_best_reply_path @reply
    assert_redirected_to '/users/login'
  end

  test "unauthorized users cannot unselect best replies" do
    delete select_best_reply_path @reply
    assert_redirected_to '/users/login'
  end

  test "post owner can select best replies" do
    login_as @post_owner
    post select_best_reply_path @reply
    assert_response :redirect
  end

  test "post owner can unselect best replies" do
    login_as @post_owner
    delete select_best_reply_path @reply
    assert_response :redirect
  end
end
