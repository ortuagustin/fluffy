class Subscription < ApplicationRecord
  belongs_to :subscriber, class_name: 'User'
  belongs_to :subscribable, polymorphic: true
end
