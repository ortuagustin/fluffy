require 'test_helper'

class PostTest < ActiveSupport::TestCase
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
end