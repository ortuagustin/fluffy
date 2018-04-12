class PostPolicy < ApplicationPolicy
  def pin?
    user.username == 'admin'       # to-do: chequear por el rol
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