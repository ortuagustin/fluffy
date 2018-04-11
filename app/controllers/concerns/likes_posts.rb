module LikesPosts
  include LikesModels

  extend ActiveSupport::Concern

  included do
    before_action :set_post
  end
protected
  def record
    @post
  end

  def set_post
    @post = Post.find post_id
  end

  def post_id
    params.require(:id)
  end

  def redirect_fallback
    @post.path
  end
end