require 'test_helper'

class RepliesLikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reply = replies(:two)
    @user = users(:teacher)
    @owner = users(:student)
  end

  test "unauthorized users cannot like replies" do
    post @reply.like_path
    assert_redirected_to_login
  end

  test "unauthorized users cannot unlike replies" do
    delete @reply.like_path
    assert_redirected_to_login
  end

  test "authorized users can like replies" do
    login_as @user
    post @reply.like_path
    assert_response :redirect
  end

  test "authorized users can unlike replies" do
    login_as @user
    delete @reply.like_path
    assert_response :redirect
  end

  test "owner cannot like its replies" do
    login_as @owner
    post @reply.like_path
    assert_response :forbidden
  end

  test "owner cannot unlike its replies" do
    login_as @owner
    delete @reply.like_path
    assert_response :forbidden
  end

  test "it returns the JSON representation of the reply for xhr requests" do
    login_as @user
    post @reply.like_path, params: { format: 'json' }

    assert_response :success
    assert_equal @reply.to_json, response.body
  end
end
