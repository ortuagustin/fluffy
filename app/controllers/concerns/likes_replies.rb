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
    @reply.post_id
  end

  def course_id
    @reply.post.course_id
  end

  def redirect_fallback
    course_post_path(course_id, post_id)
  end
end