class PostsDislikesController < ApplicationController
  before_action :set_course, :set_post

  def create
    authorize @post, :not_owner?
    @post.disliked_by current_user
    sned_response(t 'posts.flash.disliked')
  end

  def destroy
    authorize @post, :not_owner?
    @post.undisliked_by current_user
    sned_response(t 'posts.flash.undisliked')
  end
private
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

  def sned_response(notice)
    respond_to do |format|
      format.html { redirect_back fallback_location: redirect_fallback, notice: notice }
      format.json { render json: @post, status: :ok }
    end
  end

  def redirect_fallback
    course_post_path(@course, @post)
  end
end
