class Post < ApplicationRecord
  include Likeable
  include Subscribable

  paginates_per 10          ## Kaminari

  belongs_to :course
  belongs_to :user
  belongs_to :best_reply, class_name: 'Reply', foreign_key: 'best_reply_id', optional: true
  has_many :replies, -> { order(created_at: :asc) }, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, length: { maximum: 100 }

  alias_method :owner, :user

  def is_best_reply?(reply)
    if has_best_reply? then
      best_reply.id == reply.id
    else
      false
    end
  end

  def has_best_reply?
    best_reply.present?
  end

  def replies_except_best
    return replies unless has_best_reply?

    Kaminari.paginate_array(replies.reject { |reply| is_best_reply?(reply) })
  end

  def like_path
    like_course_post_path(course_id: course_id, id: id)
  end

  def dislike_path
    dislike_course_post_path(course_id: course_id, id: id)
  end

  def subscribe_path
    subscribe_post_path(id: id)
  end
end
