class RepliesController < ApplicationController
  before_action :set_post, only: [:create, :update]
  before_action :set_reply, only: [:update, :destroy]

  # POST /courses/:course_id/posts/:post_id/replies
  # POST /courses/:course_id/posts/:post_id/replies.json
  def create
    @reply = Reply.new(reply_params)

    respond_to do |format|
      if @reply.save
        format.html { redirect_to controller: "posts", action: "show", id: @post.id, replies_page: new_reply_page, anchor: @reply.id }
        format.json { render json: @reply, status: :created }
      else
        render_errors(@reply, format)
      end
    end
  end

  # PATCH/PUT /courses/:course_id/posts/:post_id/replies/:reply_id
  # PATCH/PUT /courses/:course_id/posts/:post_id/replies/:reply_id.json
  def update
    respond_to do |format|
      if @reply.update(reply_params)
        format.html { redirect_to controller: "posts", action: "show", id: @post.id, replies_page: new_reply_page, anchor: @reply.id }
        format.json { render json: @reply, status: :ok }
      else
        render_errors(@reply, format)
      end
    end
  end

  # DELETE /courses/:course_id/posts/:post_id/replies/:reply_id.json
  def destroy
    @reply.destroy

    respond_to do |format|
      format.html { redirect_to course_posts_path(course_id), notice: (t 'posts.flash.deleted') }
      format.json { head :no_content }
    end
  end
private
  def set_reply
    @reply = Reply.find(params[:id])
  end

  def set_post
    @post = Post.find(post_id)
  end

  def reply_params
    params.require(:reply).permit(:body, :user_id, :post_id)
  end

  def post_id
    params.require(:post_id)
  end

  def new_reply_page
    @post.replies.page.total_pages
  end

  def render_errors(reply, format)
    format do
      format.html { redirect_to controller: "posts", action: "show", id: reply.id }
      format.json { render json: reply.errors, status: :unprocessable_entity }
    end
  end
end
