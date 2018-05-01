require 'test_helper'

class RepliesNotificationsTest < ActiveSupport::TestCase
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
end
