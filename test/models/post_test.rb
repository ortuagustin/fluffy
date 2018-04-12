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

  test "it should not have a best reply by default" do
    assert_nil @post.best_reply
    refute @post.has_best_reply?
  end

  test "it can mark a reply as the best" do
    refute @post.has_best_reply?

    reply = Reply.create(body: 'test', user: @post.user)
    @post.replies << reply
    @post.best_reply = reply
    @post.save!

    post = Post.find(@post.id)

    assert_not_nil post.best_reply
    assert post.has_best_reply?
    assert_equal reply, post.best_reply
  end

  test "it can only have ony reply as the best" do
    reply = Reply.create(body: 'reply', post: @post, user: @post.user)
    best_reply = Reply.create(body: 'best_reply', post: @post, user: @post.user)
    @post.replies << [reply, best_reply]
    @post.best_reply = best_reply
    @post.save!

    assert_equal best_reply, @post.best_reply, 'expected best reply was not the post actual best reply'
    refute reply.is_best_reply?, 'this reply should not be the best'
    assert best_reply.is_best_reply?, 'this reply should be the best'
  end

  test "it updates best reply reference when marking a reply as the best" do
    reply = Reply.create(body: 'reply', post: @post, user: @post.user)
    first_best_reply = Reply.create(body: 'best_reply', post: @post, user: @post.user)
    @post.replies << [reply, first_best_reply]
    @post.save!

    first_best_reply.mark_best_reply
    assert_equal first_best_reply, @post.best_reply, 'expected best reply was not the post actual best reply'

    new_best_reply = Reply.create(body: 'new_best_reply', post: @post, user: @post.user)
    new_best_reply.mark_best_reply

    assert_equal new_best_reply, @post.best_reply, 'it did not update the post best reply to the newest one'
    refute first_best_reply.is_best_reply?, 'first best reply should no longer be the best reply of the post'
    assert new_best_reply.is_best_reply?, 'new best reply should be the best reply of post'
  end

  test "it can return all replies except the best given a best reply is present" do
    post = Post.create(title: 'test', body: 'test', course: @post.course, user: @post.user)
    reply = Reply.create(body: 'reply', post: @post, user: @post.user)
    best_reply = Reply.create(body: 'best_reply', post: @post, user: @post.user)
    post.replies << [reply, best_reply]
    post.best_reply = best_reply
    post.save!

    assert_equal 2, post.replies.size
    assert_equal 1, post.replies_except_best.size
    assert_not_equal best_reply, post.replies_except_best.first
    assert_equal @post.replies, @post.replies_except_best, 'collections should match since @post does not have a best reply'
  end

  test "it can be liked by a user" do
    user = users(:student)

    refute user.liked? @post
    assert_equal 0, @post.likes.size
    assert_equal 0, @post.like_score

    @post.liked_by user

    assert_equal 1, @post.likes.size
    assert_equal 1, @post.like_score
    assert user.liked? @post
  end

  test "a user who liked it, can undo the like" do
    user = users(:student)
    @post.liked_by user
    assert_equal 1, @post.like_score

    @post.unliked_by user

    refute user.liked? @post
    assert_equal 0, @post.like_score
  end

  test "it can only be liked once per user" do
    user = users(:student)

    @post.liked_by user
    @post.liked_by user

    assert_equal 1, @post.likes.size
    assert_equal 1, @post.like_score
  end

  test "it can be disliked by a user" do
    user = users(:student)

    refute user.disliked? @post
    assert_equal 0, @post.dislikes.size
    assert_equal 0, @post.like_score

    @post.disliked_by user

    assert_equal 1, @post.dislikes.size
    assert_equal -1, @post.like_score
    assert user.disliked? @post
  end

  test "a user who diliked it, can undo the like" do
    user = users(:student)
    @post.disliked_by user
    assert_equal -1, @post.like_score

    @post.undisliked_by user

    refute user.disliked? @post
    assert_equal 0, @post.like_score
  end

  test "it can only be disliked once per user" do
    user = users(:student)

    @post.disliked_by user
    @post.disliked_by user

    assert_equal 1, @post.dislikes.size
    assert_equal -1, @post.like_score
  end

  test "it can be subscribed to" do
    user = users(:student)

    assert @post.subscribers.empty?
    refute user.subscribed_to? @post

    @post.add_subscription_for user

    assert_equal 1, @post.subscribers.size
    assert @post.subscribers.include? user

    assert user.subscribed_to? @post
  end

  test "it can only be subscribed once per user" do
    user = users(:student)

    @post.add_subscription_for user
    @post.add_subscription_for user

    assert_equal 1, @post.subscribers.size
    assert_equal 1, user.subscriptions.size
  end

  test "it should automatically subscribe its owner when created" do
    user = users(:student)
    post = Post.create(title: 'test', body: 'test', course: Course.first, user: user)

    assert_equal 1, post.subscribers.size
    assert_equal 1, user.subscriptions.size
    assert user.subscribed_to? post
  end

  test "its subscription may be removed" do
    user = users(:student)

    @post.add_subscription_for user

    assert_equal 1, @post.subscribers.size
    assert_equal 1, user.subscriptions.size
    assert user.subscribed_to? @post

    @post.remove_subscription_for user

    assert_equal 0, @post.subscribers.size
    assert_equal 0, user.subscriptions.size
    refute user.subscribed_to? @post
  end

  test "it returns the most recent reply" do
    recently_updated_reply = Reply.create(body: 'test', user: User.first, created_at: 5.days.ago)
    old_reply = Reply.create(body: 'test', user: User.first, created_at: 15.days.ago)

    @post.replies << recently_updated_reply
    @post.replies << old_reply

    recently_updated_reply.touch

    assert_equal recently_updated_reply, @post.most_recent_reply
    assert_equal old_reply, @post.replies.first
    assert_equal recently_updated_reply, @post.replies.second
  end
end
