class Post < ApplicationRecord
  include Likeable

  paginates_per 10          ## Kaminari

  belongs_to :course
  belongs_to :user
  belongs_to :best_reply, class_name: 'Reply', foreign_key: 'best_reply_id', optional: true
  has_many :replies, -> { order(created_at: :asc) }, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, length: { maximum: 100 }

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
end
