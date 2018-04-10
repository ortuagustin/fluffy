module Likeable
  extend ActiveSupport::Concern

  included do
    include Rails.application.routes.url_helpers
    acts_as_votable           ## acts_as_votable
  end

  def likes
    get_likes
  end

  def dislikes
    get_dislikes
  end

  def like_score
    weighted_score
  end

  def as_json(options = {})
    super options.merge :methods => [:like_score]
  end

  def like_path
    raise NotImplementedError
  end

  def dislike_path
    raise NotImplementedError
  end
end