require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  test "it has a name" do
    role = Role.create!(name: 'test')
    assert_equal 'test', role.name
  end

  test "it can be compared against a symbol" do
    role = Role.create!(name: 'test')
    assert_equal role, :test
  end

  test "it can be compared against another Role" do
    first = Role.create!(name: 'first')
    second = Role.create!(name: 'second')

    assert_equal first, first
    assert_not_equal first, second
    assert_not_equal second, first
  end

  test "equality is case insensitive" do
    role = Role.create!(name: 'Test')
    assert_equal role, :test
  end

  test "it can be found by its name as a symbol" do
    assert_difference('Role.count') do
      Role.create!(name: 'test')
      assert_not_nil Role.find_by_sym :test
      assert_not_nil Role.find_by_sym :TEST
    end
  end

  test "it creates the guest Role if it does not exist" do
    assert_not_nil Role.guest
  end

  test "it creates the admin Role if it does not exist" do
    assert_not_nil Role.admin
  end
end