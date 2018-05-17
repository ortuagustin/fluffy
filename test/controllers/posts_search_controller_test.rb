require 'test_helper'

class PostsSearchControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course= Course.first
    @user = User.first
  end

  test "unauthenticated users cannot search posts" do
    get @course.forum_search_path
    assert_redirected_to_login
  end

  test "authenticated users can search posts" do
    login_as @user
    get @course.forum_search_path, params: { format: 'json' }
    assert_response :success
  end

  test "search response should contain the post's title and body" do
    first_post = Post.create!(title: 'first elasticsearch post', body: 'first post body', course: @course, user: @user)
    second_post = Post.create!(title: 'second elasticsearch post', body: 'second post body', course: @course, user: @user)
    Post.import

    login_as @user
    get @course.forum_search_path('elasticsearch'), params: { format: 'json' }
    assert_response :success

    assert_equal 2, json_response.size, 'it should return two posts'

    assert_equal first_post.title, json_response[0]._source.title, "the first post's title does not match"
    assert_equal first_post.body, json_response[0]._source.body, "the first post's body does not match"
    assert_equal first_post.path, json_response[0]._source.path, "the first post's path does not match"

    assert_equal second_post.title, json_response[1]._source.title, "the second post's title does not match"
    assert_equal second_post.body, json_response[1]._source.body, "the second post's body does not match"
    assert_equal second_post.path, json_response[1]._source.path, "the second post's path does not match"
  end
end

