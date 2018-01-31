require 'test_helper'

class TestTest < ActiveSupport::TestCase
  setup do
    @current_course = courses(:current_course)
    @first_test = tests(:first_test)
    @second_test = tests(:second_test)
    @float_test = tests(:float_test)
  end

#region testing attributes presence
  test "should not accept a test without a title" do
    @first_test.title = nil
    assert @first_test.invalid?
  end

  test "should not accept a test with a blank title" do
    @first_test.title = ''
    assert @first_test.invalid?
  end

  test "should not accept a test without an evaluation datetime" do
    @first_test.evaluated_at = nil
    assert @first_test.invalid?
  end

  test "should not accept a test without a passing_score" do
    @first_test.passing_score = nil
    assert @first_test.invalid?
  end

  test "should not accept a test with a blank passing_score" do
    @first_test.passing_score = ''
    assert @first_test.invalid?
  end

  test "should not accept a test with a non-numeric passing_score" do
    @first_test.passing_score = 'foo'
    assert @first_test.invalid?
  end
#endregion

  test "should not accept a test with a negative passing_score" do
    @first_test.passing_score = -1
    assert @first_test.invalid?
    @second_test.passing_score = -10
    assert @second_test.invalid?
  end

  test "should not accept a test with a passing_score greater than ten" do
    @second_test.passing_score = 11
    assert @second_test.invalid?
  end

  test "should accept a test with a valid passing_score" do
    @first_test.passing_score = 1
    assert @first_test.valid?
    @second_test.passing_score = 10
    assert @second_test.valid?
  end

  test "should not accept a test with an invalid evaluation datetime" do
    @first_test.evaluated_at = 'foo'
    assert @first_test.invalid?
  end

  test "should not accept a test with a evaluation datetime in the past" do
    @first_test.evaluated_at = 2.year.ago
    assert @first_test.invalid?
  end

  test "should accept a test with a valid evaluation datetime" do
    @first_test.evaluated_at = Date.today
    assert @first_test.valid?
    @second_test.evaluated_at = 30.days.since
    assert @second_test.valid?
  end

  test "should not accept a test that does not belong to a course" do
    @first_test.course = nil
    assert @first_test.invalid?
  end

  test "a test should have many results" do
    assert @first_test.results
  end

  test "deleting a test should delete its results" do
    test_id = @first_test.id
    @first_test.destroy
    results = TestResult.where(test_id: test_id)
    assert results.empty?
  end

  test "test getting Tests from a Course" do
    tests_from_my_course = Test.from_course(@current_course)
    assert_equal 3, tests_from_my_course.count
    assert tests_from_my_course.exists? @first_test.id
    assert tests_from_my_course.exists? @second_test.id
    assert tests_from_my_course.exists? @float_test.id
  end

  test "test getting Tests from a Course given it's id" do
    tests_from_my_course = Test.from_course_id(@current_course.id)
    assert_equal 3, tests_from_my_course.count
    assert tests_from_my_course.exists? @first_test.id
    assert tests_from_my_course.exists? @second_test.id
    assert tests_from_my_course.exists? @float_test.id
  end

  test "it returns the amount of students that passed a test" do
    assert_equal 1, @first_test.passed_count
  end

  test "it returns the amount of students that were present on a test" do
    assert_equal 1, @first_test.attended_count
  end

  test "it returns the amount of students that were missing on a test" do
    assert_equal 1, @first_test.missing_count
  end

  test "it returns the amount of students that failed a test" do
    assert_equal 0, @first_test.failed_count
  end
end
