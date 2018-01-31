require 'test_helper'

class CourseSummaryTest < ActiveSupport::TestCase
  setup do
    @current_course = courses(:current_course)
    @prior_course = courses(:prior_course)
    @current_summary = @current_course.summary
    @prior_summary = @prior_course.summary
    @current_course_tests = @current_summary.tests
    @prior_course_tests = @prior_summary.tests
    @first_test_from_current = tests(:first_test)
    @second_test_from_current = tests(:second_test)
    @float_test_from_current = tests(:float_test)
  end

  test "course without tests should return empty summary" do
    assert @prior_summary.empty?
    assert @prior_course_tests.empty?
  end

  test "course witht tests should return summary with tests" do
    assert_not @current_summary.empty?
    assert_equal 3, @current_summary.test_count

    assert_not @current_course_tests.empty?
    assert_equal 3, @current_course_tests.count
  end

  test "test attended_count returns expected result" do
    assert_equal 0, @float_test_from_current.attended_count
    assert_equal 1, @first_test_from_current.attended_count

    students(:foo_bar).test_results << TestResult.create(test: @first_test_from_current, score: 1)
    assert_equal 2, @first_test_from_current.attended_count
  end

  test "test passed_count returns expected result" do
    assert_equal 0, @float_test_from_current.passed_count
    assert_equal 1, @first_test_from_current.passed_count
  end

  test "test failed_count returns expected result" do
    assert_equal 0, @float_test_from_current.failed_count
    assert_equal 1, @second_test_from_current.failed_count
  end

  test "test missing_count returns expected result" do
    students(:foo_bar).test_results << TestResult.create(test: @first_test_from_current, score: 1)
    assert_equal 0, @first_test_from_current.missing_count
    assert_equal 1, @second_test_from_current.missing_count
    assert_equal 2, @float_test_from_current.missing_count
  end

  test "test passed_average returns expected result" do
    assert_equal 1, @first_test_from_current.passed_average
    assert_equal 0, @float_test_from_current.passed_average
    students(:foo_bar).test_results << TestResult.create(test: @first_test_from_current, score: 1)
    assert_equal 0.5, @first_test_from_current.passed_average
  end

  test "it returns passed_average formatted as percentage" do
    students(:foo_bar).test_results << TestResult.create(test: @first_test_from_current, score: 1)
    expected = '50.00%'
    actual = @first_test_from_current.passed_average_percentage
    assert_equal expected, actual
  end
end