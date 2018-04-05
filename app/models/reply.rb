class Reply < ApplicationRecord
  paginates_per 15

  belongs_to :user
  belongs_to :post, counter_cache: true

  validates :body, presence: true
end
