class RepliesController < ApplicationController
  before_action :set_reply, only: [:update, :destroy]

  # POST /courses/:course_id/posts/:post_id/replies.json
  def create
    @reply = Reply.new(reply_params)

    respond_to do |format|
      if @reply.save
        format.html { }
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
        format.html { }
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

  def reply_params
    params.require(:reply).permit(:body, :user_id, :post_id)
  end

  def render_errors(errors)
    render json: errors, status: :unprocessable_entity
  end
end
