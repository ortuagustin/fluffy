class PostsStickyController < ApplicationController
  include SendsRedirectBackResponses

  before_action :set_post

  def create
    authorize @post, :pin?
    @post.pin
    send_redirect_back @post, t('posts.flash.pinned')
  end

  def destroy
    authorize @post, :pin?
    @post.unpin
    send_redirect_back @post, t('posts.flash.unpinned')
  end
protected
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
