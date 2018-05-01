require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  test "notifications may be marked as read" do
    receiver = User.first
    post = Post.first
    post.add_subscription_for receiver

    post.replies << Reply.new(user: User.last, body: 'test')
    post.save

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
