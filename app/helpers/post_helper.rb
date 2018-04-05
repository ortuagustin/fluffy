module PostHelper
  def time_since_posted(post)
    "#{distance_of_time_in_words_to_now(post.created_at)} ago..."
  end
end