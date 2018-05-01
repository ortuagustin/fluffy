class NotificationsController < ApplicationController

  # GET /notifications/all
  def all
    @notifications = current_user.notifications.page(params[:page])

    respond_to do |format|
      format.html { render 'index' }
      format.json { render json: @notifications, status: :ok }
    end
  end

  # GET /notifications/unread
  def unread
    @notifications = current_user.unread_notifications.page(params[:page])

    respond_to do |format|
      format.html { render 'index' }
      format.json { render json: @notifications, status: :ok }
    end
  end

  # POST /notifications/read
  def read
    render json: current_user.read_notifications!, status: :ok
  end
end
