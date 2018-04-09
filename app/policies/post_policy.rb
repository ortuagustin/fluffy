class PostPolicy < ApplicationPolicy
  def update?
    record.user == user
  end
end