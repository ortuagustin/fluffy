class Post < ApplicationRecord
  belongs_to :course
  belongs_to :user

  validates :title, :body, presence: true
  validates :title, length: { maximum: 100 }
end
