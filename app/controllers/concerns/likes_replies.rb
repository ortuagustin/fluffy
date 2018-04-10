module LikesReplies
  include LikesModels
  extend ActiveSupport::Concern

  included do
    before_action :set_reply
  end
protected
  def record
    @reply
  end

  def set_reply
    @reply = Reply.find reply_id
  end

  def reply_id
    params.require(:id)
  end

  def post_id
    post_params.require(:post_id)
  end

  def course_id
    course_params.require(:course_id)
  end

  def post_params
    params.permit(:post_id)
  end

  def course_params
    params.permit(:course_id)
  end

  def redirect_fallback
    course_post_path(course_id, post_id, @reply)
  end
end