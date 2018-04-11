class Reply < ApplicationRecord
  include Likeable

  paginates_per 15

  belongs_to :user
  belongs_to :post, counter_cache: true, touch: true

  validates :body, presence: true

  def is_best_reply?
    post.is_best_reply? self
  end

  def mark_best_reply
    post.update(best_reply: self)
  end

  def unmark_best_reply
    post.update(best_reply: nil)
  end

  def like_path
    like_course_post_reply_path(course_id: post.course_id, post_id: post_id, id: id)
  end

  def dislike_path
    dislike_course_post_reply_path(course_id: post.course_id, post_id: post_id, id: id)
  end
end
