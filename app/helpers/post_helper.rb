module PostHelper
  def time_since_posted(post)
    "#{distance_of_time_in_words_to_now(post.created_at)} ..."
  end

  def post_body(post, truncate)
    return post.body unless truncate

    post.body.truncate(400)
  end

  def post_title(post, truncate)
    return post.title unless truncate

    post.title.truncate(50)
  end
end