class User < ApplicationRecord
  acts_as_voter                         ## acts_as_votable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable

  has_many :posts, dependent: :destroy
  has_many :subscriptions, dependent: :destroy, foreign_key: 'subscriber_id'

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, confirmation: true

  def subscribed_to?(subscribable)
    subscriptions.where(subscribable: subscribable).any?
  end
end
