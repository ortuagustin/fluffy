class RepliesDislikesController < ApplicationController
  include LikesReplies

  def create
    dislike
  end

  def destroy
    undislike
  end
end
