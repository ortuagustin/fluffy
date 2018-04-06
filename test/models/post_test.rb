require 'test_helper'

class PostTest < ActiveSupport::TestCase
  setup do
    @post = posts(:one)
  end

  test "should not allow a post without a title" do
    @post.title = nil
    assert @post.invalid?
  end

  test "should not allow a post with a blank title" do
    @post.title = ''
    assert @post.invalid?
  end

  test "should not allow a post with a title longer than 100 characters" do
    @post.title = 'a' * 101
    assert @post.invalid?
  end

  test "should allow a post with a title with less than 100 characters" do
    @post.title = 'a' * 100
    assert @post.valid?
  end

  test "should not allow a post without a body" do
    @post.body = nil
    assert @post.invalid?
  end

  test "should not allow a post with a blank body" do
    @post.body = ''
    assert @post.invalid?
  end

  test "it must belong to a course" do
    @post.course = nil
    assert @post.invalid?
  end

  test "it must belong to a user" do
    @post.user = nil
    assert @post.invalid?
  end

  test "it has many replies" do
    assert_not_nil @post.replies
  end

  test "its replies must be ordered from least recent" do
    recent_reply = Reply.create(body: 'test', user: User.first, created_at: 5.days.ago)
    old_reply = Reply.create(body: 'test', user: User.first, created_at: 15.days.ago)

    @post.replies << recent_reply
    @post.replies << old_reply

    assert_equal old_reply, @post.replies.first
    assert_equal recent_reply, @post.replies.second
  end

  test "it knows how many replies are associated to it" do
    @post.replies << Reply.create(body: 'test', user: User.first, created_at: 5.days.ago)
    @post.replies << Reply.create(body: 'test', user: User.first, created_at: 15.days.ago)

    assert_equal 2, @post.replies_count
  end

  test "it should not be sticky by default" do
    assert_not_nil @post.is_sticky?
    refute @post.is_sticky?
  end
end
