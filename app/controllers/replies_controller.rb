class RepliesController < ApplicationController
  before_action :set_reply, only: [:update, :destroy]
  before_action :set_post, only: [:create, :update]

  # POST /courses/:course_id/posts/:post_id/replies.json
  def create
    @reply = Reply.new(reply_params)

    respond_to do |format|
      if @reply.save
        format.html { redirect_to controller: "posts", action: "show", id: @post.id, replies_page: new_reply_page, anchor: @reply.id }
        format.json { render json: @reply, status: :created }
      else
        render_errors(@reply.errors)
      end
    end
  end

  # PATCH/PUT /courses/:course_id/posts/:post_id/replies/:reply_id.json
  def update
    respond_to do |format|
      if @reply.update(reply_params)
        format.html { redirect_to controller: "posts", action: "show", id: @post.id, replies_page: new_reply_page, anchor: @reply.id }
        format.json { render json: @reply, status: :ok }
      else
        render_errors(@reply.errors)
      end
    end
  end

  # DELETE /courses/:course_id/posts/:post_id/replies/:reply_id.json
  def destroy
    @reply.destroy
    head :no_content
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

  def render_errors(errors)
    render json: errors, status: :unprocessable_entity
  end
end
