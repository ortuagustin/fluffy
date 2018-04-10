module LikesPosts
  include LikesModels

  extend ActiveSupport::Concern

  included do
    before_action :set_course, :set_post
  end
protected
  def record
    @post
  end

  def set_course
    @course = Course.find(course_id)
  end

  def post_id
    params.require(:id)
  end

  def course_id
    course_params.require(:course_id)
  end

  def set_post
    @post = @course.post(post_id)
  end

  def course_params
    params.permit(:course_id)
  end

  def redirect_fallback
    course_post_path(@course, @post)
  end
end