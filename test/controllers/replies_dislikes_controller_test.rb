require 'test_helper'

class RepliesDisdislikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reply = replies(:two)
    @user = users(:teacher)
    @owner = users(:student)
  end

  test "unauthorized users cannot dislike replies" do
    post @reply.dislike_path
    assert_redirected_to_login
  end

  test "unauthorized users cannot undislike replies" do
    delete @reply.dislike_path
    assert_redirected_to_login
  end

  test "authorized users can dislike replies" do
    login_as @user
    post @reply.dislike_path
    assert_response :redirect
  end

  test "authorized users can undislike replies" do
    login_as @user
    delete @reply.dislike_path
    assert_response :redirect
  end

  test "owner cannot dislike its replies" do
    login_as @owner
    post @reply.dislike_path
    assert_response :forbidden
  end

  test "owner cannot undislike its replies" do
    login_as @owner
    delete @reply.dislike_path
    assert_response :forbidden
  end

  test "it returns the JSON representation of the reply for xhr requests" do
    login_as @user
    post @reply.dislike_path, params: { format: 'json' }

    assert_response :success
    assert_equal @reply.to_json, response.body
  end
end
