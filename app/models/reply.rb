class Reply < ApplicationRecord
  include Likeable

  paginates_per 15

  belongs_to :user
  belongs_to :post, counter_cache: true, touch: true

  validates :body, presence: true

  after_create :notify_suscribers

  def is_best_reply?
    post.is_best_reply? self
  end

  def mark_best_reply
    post.update(best_reply: self)
  end

  def unmark_best_reply
    post.update(best_reply: nil)
  end

  def path
    reply_path(id: id)
  end

  def like_path
    like_reply_path(id: id)
  end

  def dislike_path
    dislike_reply_path(id: id)
  end

  def select_as_best_path
    select_best_reply_path(id: id)
  end
private
  def notify_suscribers
    post.subscribers_except(user).each do |subscriber|
      Notification.create!(user: user, receiver: subscriber, action: "replied", notifiable: self)
    end
  end
end
