class ReplyPolicy < ApplicationPolicy
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