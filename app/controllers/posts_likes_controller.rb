class PostsLikesController < ApplicationController
  include LikesPosts

  def create
    like
  end

  def destroy
    unlike
  end
end
