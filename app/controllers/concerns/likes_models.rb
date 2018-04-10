module LikesModels
  extend ActiveSupport::Concern

  def like
    authorize record, :not_owner?
    record.liked_by current_user
    send_response(t "#{record_tableized}.flash.liked")
  end

  def unlike
    authorize record, :not_owner?
    record.unliked_by current_user
    send_response(t "#{record_tableized}.flash.unliked")
  end

  def dislike
    authorize record, :not_owner?
    record.disliked_by current_user
    send_response(t "#{record_tableized}.flash.disliked")
  end

  def undislike
    authorize record, :not_owner?
    record.undisliked_by current_user
    send_response(t "#{record_tableized}.flash.undisliked")
  end
protected
  def send_response(notice)
    respond_to do |format|
      format.html { redirect_back fallback_location: redirect_fallback, notice: notice }
      format.json { render json: record, status: :ok }
    end
  end

  def record_tableized
    record.class.to_s.tableize
  end
end