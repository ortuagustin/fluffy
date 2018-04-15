class ReplyPolicy < ApplicationPolicy
  def update?
    owner? || admin?
  end

  def select_best?
    record.post.user == user
  end
end