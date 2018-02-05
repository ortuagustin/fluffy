require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  setup do
    @me = students(:me)
    @another_student = students(:foo_bar)
    @first_test = tests(:first_test)
    @second_test = tests(:second_test)
    @float_test = tests(:float_test)
  end

#region testing attributes presence
  test "should not accept student without a name" do
    @me.name = nil
    assert @me.invalid?
  end

  test "should not accept student with a blank name" do
    @me.name = ''
    assert @me.invalid?
  end

  test "should not accept student without a surname" do
    @me.surname = nil
    assert @me.invalid?
  end

  test "should not accept student with a blank surname" do
    @me.surname = ''
    assert @me.invalid?
  end

  test "should not accept student without a email" do
    @me.email = nil
    assert @me.invalid?
  end

  test "should not accept student with a blank email" do
    @me.email = ''
    assert @me.invalid?
  end

  test "should not accept student without a file_number" do
    @me.file_number = nil
    assert @me.invalid?
  end

  test "should not accept student with a blank file_number" do
    @me.file_number = ''
    assert @me.invalid?
  end

  test "should not accept student without a dni" do
    @me.dni = nil
    assert @me.invalid?
  end

  test "should not accept student with a blank dni" do
    @me.dni = ''
    assert @me.invalid?
  end

  test "should not accept student without a course" do
    @me.course = nil
    assert @me.invalid?
  end
#endregion

  test "should not accept student with non-numerical dni" do
    @me.dni = 'foo'
    assert @me.invalid?
  end

  test "should not accept student with invalid email" do
    @me.email = 'foo'
    assert @me.invalid?
    @me.email = 'foo@'
    assert @me.invalid?
    @me.email = 'foo@bar@com'
    assert @me.invalid?
  end

  test "should accept student with valid email" do
    @me.email = 'foo@bar.com'
    assert @me.valid?
    @me.email = 'foo@bar'
    assert @me.valid?
  end

  test "student should be unique within a course" do
    assert @me.dup.invalid?
  end

  test "dni and file_number should be unique within a course" do
    student2 = @me.dup
    assert student2.invalid?
    student2.dni = 1234567
    student2.file_number = 11324/5
    assert student2.valid?
  end

  test "should not accept student with too large file_number" do
    @me.file_number = '11329/61'
    assert @me.invalid?
  end

  test "should not accept student with too large dni" do
    @me.dni = 123456789
    assert @me.invalid?
  end

  test "should not accept student with short dni" do
    @me.dni = 1234
    assert @me.invalid?
    @me.dni = 123456
    assert @me.invalid?
  end

  test "deleting a student should delete associated test results" do
    student_id = @me.id
    @me.destroy
    results = TestResult.where(student_id: student_id)
    assert results.empty?
  end

  test "should accept a valid student" do
    assert @me.valid?
  end

  test "i attended to 2017 course first test" do
    assert @me.attended_to? @first_test
    assert_not @me.missed? @first_test
  end

  test "i missed 2017 course float test" do
    assert @me.missed? @float_test
    assert_not @me.attended_to? @float_test
  end

  test "i passed 2017 course first test" do
    assert @me.passed? @first_test
  end

  test "i failed 2017 course second test" do
    assert @me.failed? @second_test
  end

  test "i neither failed nor passed 2017 course float test because i missed it" do
    assert_not @me.failed? @float_test
    assert_not @me.passed? @float_test
  end

  test "score for test returns correct result when i passed" do
    assert_equal 5, (@me.score_for @first_test)
  end

  test "score for test returns correct result when i failed" do
    assert_equal 4, (@me.score_for @second_test)
  end

  test "score for test returns correct result when i missed" do
    assert_equal '-', (@me.score_for @float_test)
  end

  test "i attended to 2017 course first test given it's id" do
    assert @me.attended_to? @first_test.id
    assert_not @me.missed? @first_test.id
  end

  test "i missed 2017 course float test given it's id" do
    assert @me.missed? @float_test.id
    assert_not @me.attended_to? @float_test.id
  end

  test "i passed 2017 course first test given it's id" do
    assert @me.passed? @first_test.id
  end

  test "i failed 2017 course second test given it's id" do
    assert @me.failed? @second_test.id
  end

  test "i neither failed nor passed 2017 course float test because i missed it given it's id" do
    assert_not @me.failed? @float_test.id
    assert_not @me.passed? @float_test.id
  end

  test "score_for test_id returns correct result when i passed" do
    assert_equal 5, (@me.score_for @first_test.id)
  end

  test "score_for test_id returns correct result when i failed" do
    assert_equal 4, (@me.score_for @second_test.id)
  end

  test "score_for test_id returns correct result when i missed" do
    assert_equal '-', (@me.score_for @float_test.id)
  end

  test "test attended_to? with arbitrary test_id" do
    Test.delete 5
    assert @me.missed? 5
    assert_not @me.attended_to? 5
  end

  test "test getting Students from a Course" do
    students_from_my_course = @me.course.students
    assert_equal 2, students_from_my_course.count
    assert students_from_my_course.exists? @me.id
    assert students_from_my_course.exists? @another_student.id
  end

  test "it should pass the course if passed all the course tests" do
    course = courses(:current_course)
    course.tests.each do |test|
      test.save_test_results({ @me.id => test.passing_score })
    end
    assert @me.passed? course
    assert_not @me.failed? course
  end

  test "it should fail the course if failed any of the course tests" do
    course = courses(:current_course)
    assert_not @me.passed? course
    assert @me.failed? course
  end

  test "it eager loads test results" do
    student = Student.first
    assert student.association(:test_results).loaded?
  end

  test "it eager loads tests" do
    student = Student.first
    assert student.association(:tests).loaded?
  end
end
