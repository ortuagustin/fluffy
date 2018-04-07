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
end
