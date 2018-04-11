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

  def select_best?
    record.post.user == user
  end
end