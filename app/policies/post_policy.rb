class PostPolicy < ApplicationPolicy
  def pin?
    admin?
  end

  def update?
    owner?
  end
end