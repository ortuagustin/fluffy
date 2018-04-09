class ReplyPolicy < ApplicationPolicy
  def update?
    record.user == user
  end
end