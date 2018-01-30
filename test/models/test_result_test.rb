require 'test_helper'

class TestResultTest < ActiveSupport::TestCase
  setup do
    @my_first_test_result = test_results(:my_first_test_result)
    @my_second_test_result = test_results(:my_second_test_result)
  end

#region testing attributes presence
  test "should not accept a test_result without a score" do
    @my_first_test_result.score = nil
    assert @my_first_test_result.invalid?
  end

  test "should not accept a test with a blank title" do
    @my_first_test_result.score = ''
    assert @my_first_test_result.invalid?
  end

  test "should not accept a test_result that does not belong to a student" do
    @my_first_test_result.student = nil
    assert @my_first_test_result.invalid?
  end

  test "should not accept a test_result that does not belong to a test" do
    @my_first_test_result.test = nil
    assert @my_first_test_result.invalid?
  end
#endregion

  test "first test should be passed" do
    assert @my_first_test_result.passed?
  end

  test "second test should be failed" do
    assert @my_second_test_result.failed?
  end

  test "should not accept less than zero as score" do
    @my_first_test_result.score = 0
    @my_second_test_result.score = -1
    assert @my_first_test_result.invalid?
    assert @my_second_test_result.invalid?
  end

  test "should not accept a result with a score  greater than ten" do
    @my_first_test_result.score = 11
    assert @my_first_test_result.invalid?
  end

  test "a test should not allow duplicate results" do
    result = test_results(:my_first_test_result).dup
    assert result.invalid?
  end
end
