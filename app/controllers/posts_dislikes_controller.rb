class PostsDislikesController < ApplicationController
  include LikesPosts

  def create
    dislike
  end

  def destroy
    undislike
  end
end
