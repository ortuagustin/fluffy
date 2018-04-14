require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @teacher = users(:teacher)
    @student = users(:student)
  end

  test "it has may posts associated" do
    assert_equal 2, @teacher.posts.size
    assert_equal 0, @student.posts.size
  end

  test "deleting a user should delete associated posts" do
    user_id = @teacher.id
    @teacher.destroy
    posts = Post.where(user_id: user_id)
    assert posts.empty?
  end

  test "it has a default guest role" do
    user = User.create!(email: 'foo@bar.com', username: 'foo', password: '1234')
    assert user.role.present?
    assert user.role? :guest
    assert_equal user.role, :guest
  end

  test "it can be queried if it plays a given role" do
    user = User.create!(email: 'foo@bar.com', username: 'foo', password: '1234')

    assert user.role? :guest
    refute user.role? :admin
  end
end