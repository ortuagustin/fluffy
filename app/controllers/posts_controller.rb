class PostsController < ApplicationController
  before_action :set_post, except: [:index, :create, :new]
  helper_method :course_id, :user_id, :course

  # GET /courses/:course_id/posts
  def index
    @posts = course.posts.page(params[:page])
  end

  # GET /courses/:course_id/posts/:post_id
  def show
    @reply = Reply.new
  end

  # GET /courses/:course_id/posts/new
  def new
    @post = Post.new
  end

  # POST /courses/:course_id/posts
  def create
    @post = Post.new(post_params)
    @post.course_id = course_id

    if @post.save
      redirect_to course_posts_path(course_id), notice: (t 'posts.flash.created')
    else
      render :new
    end
  end

  # GET /courses/:course_id/posts/:post_id/edit
  def edit
  end

  # PATCH/PUT /courses/:course_id/posts/:post_id
  def update
    if @post.update(post_params)
      redirect_to course_post_path(course_id, @post), notice: (t 'posts.flash.updated')
    else
      render :edit
    end
  end

  # DELETE /courses/:course_id/posts/:post_id
  def destroy
    @post.destroy
    redirect_to course_posts_path(course_id), notice: (t 'posts.flash.deleted')
  end
private
  def course
    @course ||= Course.find(course_id)
  end

  def course_id
    course_params.require(:course_id)
  end

  def user_id
    current_user.id
  end

  def post_id
    params.require(:id)
  end

  def set_post
    @post = course.post(post_id)
    @replies = @post.replies.page(params[:replies_page])
  end

  def course_params
    params.permit(:course_id)
  end

  def post_params
    params.require(:post).permit(:title, :body, :user_id, :course_id)
  end
end
