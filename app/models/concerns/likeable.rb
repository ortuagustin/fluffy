module Likeable
  extend ActiveSupport::Concern

  included do
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
end