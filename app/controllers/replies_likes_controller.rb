class RepliesLikesController < ApplicationController
  include LikesReplies

  def create
    like
  end

  def destroy
    unlike
  end
end
