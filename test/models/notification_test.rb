require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  setup do
    @user = User.first
    @post = Post.first
  end

  test "user gets notification when adding a reply to a post he is suscribed" do
    receiver = @user
    @post.add_subscription_for receiver

    assert receiver.notifications.empty?, 'receiver notifications should be empty'
    assert receiver.subscribed_to?(@post), 'receiver should be subscribed to the post'

    @post.replies << Reply.new(user: User.last, body: 'test')
    @post.save

    assert receiver.notifications.any?, 'receiver should have 1 notification'
    assert_equal 1, receiver.notifications.size, 'receiver should have 1 notification'

    notification = receiver.notifications.first

    assert_equal receiver, notification.receiver, 'notification got unexpected receiver assigned'
    assert_equal User.last, notification.user, 'notification got unexpected user assigned'
  end

  test "user that replies to a post shouldnt get a notification" do
    receiver = @user
    user_that_replies = User.last
    @post.add_subscription_for user_that_replies

    assert user_that_replies.subscribed_to?(@post), 'user that replies should be subscribed to the post'
    assert user_that_replies.notifications.empty?, 'user that replies notifications should be empty'

    @post.replies << Reply.new(user: user_that_replies, body: 'test')
    @post.save

    assert user_that_replies.notifications.empty?, 'user that replies notifications should be empty'
  end

  test "user does not get a notification when adding a reply to a post he is is NOT suscribed" do
    receiver = @user

    assert receiver.notifications.empty?, 'receiver notifications should be empty'
    refute receiver.subscribed_to?(@post), 'receiver should not be subscribed'

    @post.replies << Reply.new(user: User.last, body: 'test')
    @post.save

    assert receiver.notifications.empty?, 'receiver notifications should still be empty'
  end

  test "notifications may be marked as read" do
    receiver = @user
    @post.add_subscription_for receiver

    @post.replies << Reply.new(user: User.last, body: 'test')
    @post.save

    assert_equal 1, receiver.notifications.size, 'receiver should have 1 notification'
    assert_equal 1, receiver.unread_notifications.size, 'receiver should have 1 unread notification'
    assert_equal 0, receiver.read_notifications.size, 'receiver should have 0 read notifications'
    refute receiver.notifications.first.read?, 'notification should not be marked as read'

    receiver.read_notifications!

    assert_equal 1, receiver.notifications.size, 'receiver should have 1 notification'
    assert_equal 0, receiver.unread_notifications.size, 'receiver should have 0 unread notifications'
    assert_equal 1, receiver.read_notifications.size, 'receiver should have 1 read notification'
    assert receiver.notifications.first.read?, 'notification should be marked as read'
  end
end
