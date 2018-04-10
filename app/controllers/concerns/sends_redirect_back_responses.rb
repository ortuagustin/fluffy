module SendsRedirectBackResponses
  def send_redirect_back(record, notice)
    respond_to do |format|
      format.html { redirect_back fallback_location: redirect_fallback, notice: notice }
      format.json { render json: record, status: :ok }
    end
  end

  def tableize(record)
    record.class.to_s.tableize
  end

  def redirect_fallback
    raise NotImplementedError
  end
end