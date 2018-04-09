class PostsController < ApplicationController
  before_action :set_post, except: [:index, :create, :new]
  helper_method :course_id, :user_id, :course, :has_best_reply?, :best_reply

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
  # POST /courses/:course_id/posts.json
  def create
    @post = Post.new(post_params)
    @post.course_id = course_id

    respond_to do |format|
      if @post.save
        format.html { redirect_to course_posts_path(course_id), notice: (t 'posts.flash.created') }
        format.json { render json: @post, status: :created }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /courses/:course_id/posts/:post_id/edit
  def edit
  end

  # PATCH/PUT /courses/:course_id/posts/:post_id
  # PATCH/PUT /courses/:course_id/posts/:post_id.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to course_posts_path(course_id), notice: (t 'posts.flash.updated') }
        format.json { render json: @post, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/:course_id/posts/:post_id
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to course_posts_path(course_id), notice: (t 'posts.flash.deleted') }
      format.json { head :no_content }
    end
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
    @replies = @post.replies_except_best.page(params[:replies_page])
  end

  def has_best_reply?
    @post.has_best_reply?
  end

  def best_reply
    @best_reply ||= @post.best_reply
  end

  def course_params
    params.permit(:course_id)
  end

  def post_params
    params.require(:post).permit(:title, :body, :user_id, :course_id)
  end
end
