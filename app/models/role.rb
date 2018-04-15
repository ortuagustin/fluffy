class Role < ApplicationRecord
  def self.find_by_sym(role)
    Role.find_by_name role.to_s.downcase
  end

  def self.guest
    Role.find_or_create_by!(name: 'Guest')
  end

  def self.admin
    Role.find_or_create_by!(name: 'Admin')
  end

  def ==(other)
    return super(other) if other.is_a? Role

    name.downcase.to_sym == other.downcase.to_sym
  end
end