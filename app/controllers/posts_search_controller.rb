class PostsSearchController < ApplicationController
  def index
    @posts = Post.search(params[:q]).results.to_a
    render json: @posts
  end
end
