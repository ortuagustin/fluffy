require 'test_helper'

class ReplyTest < ActiveSupport::TestCase
  setup do
    @reply = replies(:one)
  end

  test "should not allow a reply without a body" do
    @reply.body = nil
    assert @reply.invalid?
  end

  test "should not allow a reply with a blank body" do
    @reply.body = ''
    assert @reply.invalid?
  end

  test "it must belong to a post" do
    @reply.post = nil
    assert @reply.invalid?
  end

  test "it must belong to a user" do
    @reply.user = nil
    assert @reply.invalid?
  end

  test "it should not be the best reply by default" do
    assert_not_nil @reply.is_best_reply?
    refute @reply.is_best_reply?
  end

  test "it can be marked as the best reply of the post" do
    refute @reply.is_best_reply?
    @reply.mark_best_reply
    assert @reply.is_best_reply?
  end

  test "it can be unmarked as the best reply of the post" do
    refute @reply.is_best_reply?
    @reply.mark_best_reply
    assert @reply.is_best_reply?
    @reply.unmark_best_reply
    refute @reply.is_best_reply?
  end

  test "it can be liked by a user" do
    user = users(:student)

    refute user.liked? @reply
    assert_equal 0, @reply.likes.size
    assert_equal 0, @reply.like_score

    @reply.liked_by user

    assert_equal 1, @reply.likes.size
    assert_equal 1, @reply.like_score
    assert user.liked? @reply
  end

  test "a user who liked it, can undo the like" do
    user = users(:student)
    @reply.liked_by user
    assert_equal 1, @reply.like_score

    @reply.unliked_by user

    refute user.liked? @reply
    assert_equal 0, @reply.like_score
  end

  test "it can only be liked once per user" do
    user = users(:student)

    @reply.liked_by user
    @reply.liked_by user

    assert_equal 1, @reply.likes.size
    assert_equal 1, @reply.like_score
  end

  test "it can be disliked by a user" do
    user = users(:student)

    refute user.disliked? @reply
    assert_equal 0, @reply.dislikes.size
    assert_equal 0, @reply.like_score

    @reply.disliked_by user

    assert_equal 1, @reply.dislikes.size
    assert_equal -1, @reply.like_score
    assert user.disliked? @reply
  end

  test "a user who diliked it, can undo the like" do
    user = users(:student)
    @reply.disliked_by user
    assert_equal -1, @reply.like_score

    @reply.undisliked_by user

    refute user.disliked? @reply
    assert_equal 0, @reply.like_score
  end

  test "it can only be disliked once per user" do
    user = users(:student)

    @reply.disliked_by user
    @reply.disliked_by user

    assert_equal 1, @reply.dislikes.size
    assert_equal -1, @reply.like_score
  end
end
