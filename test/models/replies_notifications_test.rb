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

    assert receiver.notifications.any?, 'receiver should have notifications'
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

  test "user gets notification when a reply from a post he is suscribed is marked as best" do
    receiver = User.last
    reply = Reply.create!(user: @user, post: @post, body: 'test')
    @post.add_subscription_for receiver

    assert receiver.notifications.empty?, 'receiver notifications should be empty'
    assert receiver.subscribed_to?(@post), 'receiver should be subscribed to the post'

    reply.mark_best_reply

    assert receiver.notifications.any?, 'receiver should have notifications'
    assert_equal 1, receiver.notifications.size, 'receiver should have 1 notification'

    notification = receiver.notifications.first

    assert_equal receiver, notification.receiver, 'notification got unexpected receiver assigned'
    assert_nil notification.user
  end

  test "user does not get a notification when a reply from a post he is NOT suscribed is marked as best" do
    receiver = User.last
    reply = Reply.create!(user: @user, post: @post, body: 'test')

    assert receiver.notifications.empty?, 'receiver notifications should be empty'
    refute receiver.subscribed_to?(@post), 'receiver should not be subscribed'

    reply.mark_best_reply

    assert receiver.notifications.empty?, 'receiver notifications should still be empty'
  end

  test "post owner shouldnt get a notification when he selects a reply as the best" do
    owner = @post.owner
    reply = Reply.create!(user: User.last, post: @post, body: 'test')
    @post.add_subscription_for owner

    assert owner.subscribed_to?(@post), 'post owner should be subscribed to the post'
    assert owner.notifications.empty?, 'post owner notifications should be empty'

    reply.mark_best_reply

    assert owner.notifications.empty?, 'post owner notifications should be empty'
  end

  test "user gets notification when a reply from a post he is suscribed gets a like" do
    receiver = User.last
    reply = Reply.create!(user: @user, post: @post, body: 'test')
    @post.add_subscription_for receiver

    assert receiver.notifications.empty?, 'receiver notifications should be empty'
    assert receiver.subscribed_to?(@post), 'receiver should be subscribed to the post'

    reply.liked_by @post.owner

    assert receiver.notifications.any?, 'receiver should have notifications'
    assert_equal 1, receiver.notifications.size, 'receiver should have 1 notification'

    notification = receiver.notifications.first

    assert_equal receiver, notification.receiver, 'notification got unexpected receiver assigned'
    assert_equal @post.owner, notification.user, 'notification got unexpected user assigned'
  end

  test "user that likes a reply shouldnt get a notification" do
    receiver = @user
    user_that_likes = User.last
    reply = Reply.create!(user: @user, post: @post, body: 'test')
    @post.add_subscription_for user_that_likes

    assert user_that_likes.subscribed_to?(@post), 'user that likes should be subscribed to the post'
    assert user_that_likes.notifications.empty?, 'user that likes notifications should be empty'

    reply.liked_by user_that_likes

    assert user_that_likes.notifications.empty?, 'user that likes notifications should be empty'
  end

  test "user does not get a notification when a reply from a post he is NOT suscribed gets a like" do
    receiver = User.last
    reply = Reply.create!(user: @user, post: @post, body: 'test')

    assert receiver.notifications.empty?, 'receiver notifications should be empty'
    refute receiver.subscribed_to?(@post), 'receiver should NOT be subscribed to the post'

    reply.liked_by @user

    assert receiver.notifications.empty?, 'receiver notifications should still be empty'
  end
end
