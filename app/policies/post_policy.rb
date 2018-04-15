class PostPolicy < ApplicationPolicy
  def pin?
    user.role? :admin
  end

  def update?
    owner?
  end

  def owner?
    record.user == user
  end

  def not_owner?
    not owner?
  end
end