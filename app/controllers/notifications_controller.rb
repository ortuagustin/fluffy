class NotificationsController < ApplicationController
  def unread
    render json: current_user.unread_notifications, status: :ok
  end

  def all
    render json: current_user.notifications, status: :ok
  end

  def read
    render json: current_user.read_notifications!, status: :ok
  end
end
