class Post < ApplicationRecord
  extend FriendlyId                                                             ## friendly_id

  include Likeable
  include Subscribable
  include ElasticSearchModel
  mappings dynamic: 'false' do
    indexes :title, type: 'text'
    indexes :body, type: 'text'
    indexes :path, type: 'text'
  end

  paginates_per 10                                                              ## Kaminari
  friendly_id :title, use: :slugged                                             ## friendly_id

  belongs_to :course
  belongs_to :user
  belongs_to :best_reply, class_name: 'Reply', foreign_key: 'best_reply_id', optional: true
  has_many :replies, -> { order(created_at: :asc) }, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, length: { maximum: 100 }

  alias_method :owner, :user

  def self.find_by_slug(slug)
    Post.friendly.find slug
  end

  def sticky?
    is_sticky
  end

  def pin
    update(is_sticky: true)
  end

  def unpin
    update(is_sticky: false)
  end

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

  def most_recent_reply
    replies.reorder(updated_at: :desc).first
  end

  def path
    post_path(id: slug)
  end

  def replies_path
    post_replies_path(post_id: id)
  end

  def like_path
    like_post_path(id: id)
  end

  def dislike_path
    dislike_post_path(id: id)
  end

  def subscribe_path
    subscribe_post_path(id: id)
  end

  def pin_path
    pin_post_path(id: id)
  end

  def as_indexed_json(options={})
    self.as_json({
      only: [:title, :body],
      methods: [:path],
    })
  end
end
