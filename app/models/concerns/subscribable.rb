module Subscribable
  extend ActiveSupport::Concern

  included do
    include GeneratesUrls

    has_many :subscriptions, dependent: :destroy, as: :subscribable
    has_many :subscribers, through: :subscriptions

    after_create :subscribe_owner, if: :subscribe_on_create?
  end

  def add_subscription_for(subscriber)
    subscriber.subscriptions.find_or_create_by(subscribable: self)
  end

  def remove_subscription_for(subscriber)
    subscriber.subscriptions.where(subscribable: self).destroy_all
  end

  def subscribe_owner
    add_subscription_for owner
  end

  def subscribe_on_create?
    true
  end

  def owner
    raise NotImplementedError
  end

  def subscribe_path
    raise NotImplementedError
  end
end