class RepliesController < ApplicationController
  before_action :set_reply, only: [:show, :update, :destroy]

  # GET /replies/:id
  def show
    redirect_to_reply @post, @reply
  end

  # POST /posts/:post_id/replies
  # POST /posts/:post_id/replies.json
  def create
    @reply = Reply.new(create_reply_params)
    @post = Post.find @reply.post_id

    respond_to do |format|
      if @reply.save
        format.html { redirect_to_reply @post, @reply }
        format.json { render json: @reply, status: :created }
      else
        render_errors(@reply, format)
      end
    end
  end

  # PATCH/PUT /replies/:reply_id
  # PATCH/PUT /replies/:reply_id.json
  def update
    authorize @reply

    respond_to do |format|
      if @reply.update(update_reply_params)
        format.html { redirect_to_reply @post, @reply }
        format.json { render json: @reply, status: :ok }
      else
        render_errors(@reply, format)
      end
    end
  end

  # DELETE /replies/:reply_id
  # DELETE /replies/:reply_id.json
  def destroy
    @reply.destroy

    respond_to do |format|
      format.html { redirect_to @reply.post.course.forum_path, notice: (t 'replies.flash.deleted') }
      format.json { head :no_content }
    end
  end
private
  def set_reply
    @reply = Reply.find reply_id
    @post = @reply.post
  end

  def create_reply_params
    params.require(:reply).permit(:body, :user_id, :post_id)
  end

  def update_reply_params
    params.require(:reply).permit(:body)
  end

  def course_id
    @post.course_id
  end

  def post_id
    @post.id
  end

  def reply_id
    params.require(:id)
  end

  def page_for(post, reply)
    position = post.replies.where('id <= ?', reply.id).count
    (position.to_f/Reply.default_per_page).ceil
  end

  def redirect_to_reply(post, reply)
    redirect_to controller: "posts", action: "show", id: post.slug, replies_page: page_for(post, reply), anchor: reply.id
  end

  def render_errors(reply, format)
    format.html { redirect_to controller: "posts", action: "show", course_id: course_id, id: post_id }
    format.json { render json: reply.errors, status: :unprocessable_entity }
  end
end
