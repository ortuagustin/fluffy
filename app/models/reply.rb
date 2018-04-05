class Reply < ApplicationRecord
  paginates_per 15

  belongs_to :user
  belongs_to :post

  validates :body, presence: true
end
