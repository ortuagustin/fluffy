class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :receiver, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  scope :read, ->{ where.not read_at: nil }
  scope :unread, ->{ where read_at: nil }

  def read?
    read_at.present?
  end

  def partial_path
    "notifications/#{notifiable_type.pluralize.downcase}/#{notifiable_action}"
  end
end
