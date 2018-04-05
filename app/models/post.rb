class Post < ApplicationRecord
  belongs_to :course
  belongs_to :user
  has_many :replies, -> { order created_at: :asc }, dependent: :destroy

  validates :title, :body, presence: true
  validates :title, length: { maximum: 100 }
end
