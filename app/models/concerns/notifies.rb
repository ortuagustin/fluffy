module Notifies
  extend ActiveSupport::Concern

  def notify(sender, receivers, action)
    receivers.each do |receiver|
      Notification.create!(user: sender, receiver: receiver, notifiable_action: action, notifiable: self)
    end
  end
end