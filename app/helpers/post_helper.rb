module PostHelper
  def time_since_posted(post)
    time_since(post.created_at)
  end

  def time_since(time)
    "#{distance_of_time_in_words_to_now(time)} ..."
  end

  def post_body(post, truncate, length = 400)
    return post.body unless truncate

    post.body.truncate(length)
  end

  def post_title(post, truncate, length = 75)
    return post.title unless truncate

    post.title.truncate(length)
  end
end