class PostsSubscriptionsController < ApplicationController
  include SendsRedirectBackResponses

  before_action :set_post

  def create
    @post.add_subscription_for current_user
    send_redirect_back @post, t("#{tableize(@post)}.flash.subscribed")
  end

  def destroy
    @post.remove_subscription_for current_user
    send_redirect_back @post, t("#{tableize(@post)}.flash.unsubscribed")
  end
protected
  def redirect_fallback
    @post.path
  end
private
  def set_post
    @post = Post.find post_id
  end

  def post_id
    params.require(:id)
  end

  def course_params
    params.permit(:course_id)
  end
end
