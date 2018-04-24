require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.first
    @post = Post.first

    @post.add_subscription_for @user
    @post.replies << Reply.new(user: User.last, body: 'test')
    @post.save
  end

  test "unauthenticated users cannot query for notifications" do
    get unread_notifications_path, params: { format: 'json' }
    assert_response :unauthorized
  end

  test "it returns the unread notifications of the authenticated user" do
    login_as @user
    get unread_notifications_path, params: { format: 'json' }

    assert_response :success
    assert_equal @user.notifications.to_json, response.body
  end

  test "it does not return already read notifications" do
    login_as @user

    post read_notifications_path, params: { format: 'json' }
    get unread_notifications_path, params: { format: 'json' }

    assert_response :success
    assert_equal [].to_json, response.body
  end

  test "it returns all notifications of the authenticated user" do
    login_as @user

    post read_notifications_path, params: { format: 'json' }
    get all_notifications_path, params: { format: 'json' }

    assert_response :success
    assert_equal @user.notifications.to_json, response.body
  end

  test "it should mark notifications as read" do
    login_as @user
    post read_notifications_path, params: { format: 'json' }

    assert_response :success
    assert @user.notifications.all? { |notification| notification.read? }
  end
end
