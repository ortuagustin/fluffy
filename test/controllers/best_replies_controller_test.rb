require 'test_helper'

class BestRepliesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reply = replies(:two)
    @post_owner = @reply.post.user
  end

  test "unauthorized users cannot select best replies" do
    post @reply.select_as_best_path
    assert_redirected_to_login
  end

  test "unauthorized users cannot unselect best replies" do
    delete @reply.select_as_best_path
    assert_redirected_to_login
  end

  test "post owner can select best replies" do
    login_as @post_owner
    post @reply.select_as_best_path
    assert_response :redirect
  end

  test "post owner can unselect best replies" do
    login_as @post_owner
    delete @reply.select_as_best_path
    assert_response :redirect
  end
end
