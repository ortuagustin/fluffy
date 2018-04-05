module PostHelper
  def time_since_posted(post)
    "#{distance_of_time_in_words_to_now(post.created_at)} ago..."
  end

  def post_body(post, truncate)
    return post.body unless truncate

    post.body.truncate(400)
  end
end