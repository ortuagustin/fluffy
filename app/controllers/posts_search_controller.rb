class PostsSearchController < ApplicationController
  def index
    response = Post.search query: { fuzzy: { title: { value: query_param } } }

    @posts = response.results.to_a
    render json: @posts
  end

private
  def query_param
    params[:q] || ''
  end
end
