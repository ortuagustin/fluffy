require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  setup do
    @current_course = courses(:current_course)
    @prior_course = courses(:prior_course)
    @me = students(:me)
    @first_test = tests(:first_test)
  end

  test "should not accept a blank year" do
    course = Course.new(year: '')
    assert course.invalid?
  end

  test "should not accept a nil year" do
    course = Course.new(year: nil)
    assert course.invalid?
  end

  test "should not accept invalid formatted year" do
    course = Course.new(year: 12)
    assert course.invalid?
    course = Course.new(year: 123)
    assert course.invalid?
    course = Course.new(year: 1234)
    assert course.invalid?
    course = Course.new(year: 12345)
    assert course.invalid?

    course = Course.new(year: 19)
    assert course.invalid?
    course = Course.new(year: 191)
    assert course.invalid?
    course = Course.new(year: 20)
    assert course.invalid?
    course = Course.new(year: 201)
    assert course.invalid?
  end

  test "should accept correctly formatted year" do
    course = Course.new(year: 1900)
    assert course.valid?
    course = Course.new(year: 2000)
    assert course.valid?
    course = Course.new(year: 2010)
    assert course.valid?
  end

  test "should not accept duplicated year" do
    course = Course.new(year: 2000)
    assert course.save
    same_course = Course.new(year: 2000)
    assert_not same_course.save
  end

  test "current_course should have me as student" do
    assert @current_course.students.include?(@me)
  end

  test "prior_course should not have me as student" do
    assert_not @prior_course.students.include?(@me)
  end

  test "deleting a course should delete associated students" do
    course_id = @current_course.id
    @current_course.destroy
    students = Student.where(course_id: course_id)
    assert students.empty?
  end

  test "deleting a course should delete associated tests" do
    course_id = @current_course.id
    @current_course.destroy
    tests = Test.where(course_id: course_id)
    assert tests.empty?
  end

  test "it returns correct student when the given student id belongs to the course" do
    course = courses(:foo_course)
    actual = course.student 1
    expected = students(:student_with_id_1)
    assert_equal expected, actual
  end

  test "it returns correct student even if the given student id is passed as string" do
    course = courses(:foo_course)
    actual = course.student '1'
    expected = students(:student_with_id_1)
    assert_equal expected, actual
  end

  test "it raises exception when the given student id doest not exist in the course" do
    assert_raises(ActiveRecord::RecordNotFound) do
      courses(:foo_course).student 12345
    end
  end

  test "it returns correct test when the given test id belongs to the course" do
    course = courses(:foo_course)
    actual = course.test 1
    expected = tests(:test_with_id_1)
    assert_equal expected, actual
  end

  test "it returns correct test even if the given test id is passed as string" do
    course = courses(:foo_course)
    actual = course.test '1'
    expected = tests(:test_with_id_1)
    assert_equal expected, actual
  end

  test "it raises exception when the given test id doest not exist in the course" do
    assert_raises(ActiveRecord::RecordNotFound) do
      courses(:foo_course).test 12345
    end
  end
end