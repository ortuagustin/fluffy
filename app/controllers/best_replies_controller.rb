class BestRepliesController < ApplicationController
  include SendsRedirectBackResponses
  include Pundit                      ## pundit

  before_action :set_reply

  def create
    authorize @reply, :select_best?
    @reply.mark_best_reply
    send_redirect_back @reply, t('replies.flash.selected_best')
  end

  def destroy
    authorize @reply, :select_best?
    @reply.unmark_best_reply
    send_redirect_back @reply, t('replies.flash.unselected_best')
  end
private
  def set_reply
    @reply = Reply.find reply_id
  end

  def reply_id
    params.require(:id)
  end

  def post_id
    @reply.post_id
  end

  def course_id
    @reply.post.course_id
  end

  def redirect_fallback
    @reply.post.path
  end
end
