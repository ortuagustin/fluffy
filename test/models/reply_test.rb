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
end
