module LikesModels
  include SendsRedirectBackResponses

  def like
    authorize record, :not_owner?
    record.liked_by current_user
    send_redirect_back record, t("#{tableize(record)}.flash.liked")
  end

  def unlike
    authorize record, :not_owner?
    record.unliked_by current_user
    send_redirect_back record, t("#{tableize(record)}.flash.unliked")
  end

  def dislike
    authorize record, :not_owner?
    record.disliked_by current_user
    send_redirect_back record, t("#{tableize(record)}.flash.disliked")
  end

  def undislike
    authorize record, :not_owner?
    record.undisliked_by current_user
    send_redirect_back record, t("#{tableize(record)}.flash.undisliked")
  end
end