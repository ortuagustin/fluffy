class Reply < ApplicationRecord
  include Likeable
  include Notifies

  paginates_per 15

  belongs_to :user
  belongs_to :post, counter_cache: true, touch: true

  validates :body, presence: true

  after_create :notify_new_reply_to_suscribers

  alias_method :owner, :user

  def path
    reply_path(id: id)
  end

  def is_best_reply?
    post.is_best_reply? self
  end

  def mark_best_reply
    post.update!(best_reply: self)
    post.reload
    notify_best_reply_to_suscribers
  end

  def unmark_best_reply
    post.update!(best_reply: nil)
  end

  def select_as_best_path
    select_best_reply_path(id: id)
  end

  def like_path
    like_reply_path(id: id)
  end

  def dislike_path
    dislike_reply_path(id: id)
  end

  def liked_by_with_notification(voter)
    liked_by_without_notification(voter)
    post.reload
    notify_like_to_suscribers(voter)
  end

  alias_method :liked_by_without_notification, :liked_by
  alias_method :liked_by, :liked_by_with_notification
private
  def notify_new_reply_to_suscribers
    notify(owner, post.subscribers_except(owner), 'created')
  end

  def notify_like_to_suscribers(voter)
    notify(voter, post.subscribers_except(voter), 'liked')
  end

  def notify_best_reply_to_suscribers
    notify(nil, post.subscribers_except(post.owner), 'marked_best')
  end
end
