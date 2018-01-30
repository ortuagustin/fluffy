require 'test_helper'

class StudentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @me = students(:me)
    @my_course = courses(:current_course)
    @foo_bar = students(:foo_bar)
    @first_test = tests(:first_test)
    @second_test = tests(:second_test)
    @float_test = tests(:float_test)
  end

  test "should get index" do
    get course_students_url(@my_course), as: :json
    assert_response :success
  end

  test "should create student non existent student" do
    @foo_bar.destroy
    assert_difference('Student.count') do
      post course_students_url(@my_course), params: {
         student: {
           dni: @foo_bar.dni, email: @foo_bar.email, file_number: @foo_bar.file_number,
           name: @foo_bar.name, surname: @foo_bar.surname, course_id: @foo_bar.course_id
           }
        }, as: :json
    end

    assert_response 201
  end

  test "should create existent student in different course" do
    course = courses(:prior_course)
    assert_difference('Student.count') do
      post course_students_url(course), params: {
         student: {
           dni: @foo_bar.dni, email: @foo_bar.email, file_number: @foo_bar.file_number,
           name: @foo_bar.name, surname: @foo_bar.surname, course_id: course.id
           }
        }, as: :json
    end

    assert_response 201
  end

  test "should show student" do
    get course_student_url(@my_course, @me), as: :json
    assert_response :success
  end

  test "should update student" do
    patch course_student_url(@my_course, @me), params: {
      student: {
        dni: @me.dni, email: @me.email, file_number: @me.file_number,
        name: @me.name, surname: @me.surname, course_id: @my_course.id
        }
     }, as: :json

    assert_response 200
  end

  test "should destroy student" do
    assert_difference('Student.count', -1) do
      delete course_student_url(@my_course, @me), as: :json
    end

    assert_response 204
  end

  test "returns empty student when requesting GET /new" do
    get students_new_url, as: :json
    assert_response 200
  end

  test "returns student with assigned course_id when requesting GET courses/course_id/new" do
    get course_students_new_url(@my_course), as: :json
    assert_equal @my_course.id, parsed_body['course_id']
    assert_response 200
  end

  test "returns 200 when attended_to on student that took a test" do
    get attended_to_course_student_url(@my_course, @me, @first_test.id), as: :json
    assert_response 200
  end

  test "returns 404 when attended_to on unexistent student" do
    @me.destroy
    get attended_to_course_student_url(@my_course, @me, @first_test.id), as: :json
    assert_response 404
  end

  test "returns false when attended_to on unexistent test" do
    dummy_test_id = @first_test.id
    @first_test.destroy
    get attended_to_course_student_url(@my_course, @me, dummy_test_id), as: :json
    refute parsed_body['value']
    assert_response 200
  end

  test "i attended to 2017 course first test" do
    get attended_to_course_student_url(@my_course, @me, @first_test.id), as: :json
    assert parsed_body['value']
    assert_response 200
  end

  test "i missed 2017 course float test" do
    get missed_course_student_url(@my_course, @me, @float_test.id), as: :json
    assert parsed_body['value']
    assert_response 200
  end

  test "i passed 2017 course first test" do
    get passed_course_student_url(@my_course, @me, @first_test.id), as: :json
    assert parsed_body['value']
    assert_response 200
  end

  test "i failed 2017 course second test" do
    get failed_course_student_url(@my_course, @me, @second_test.id), as: :json
    assert parsed_body['value']
    assert_response 200
  end

  test "i neither failed nor passed 2017 course float test because i missed it" do
    get passed_course_student_url(@my_course, @me, @float_test.id), as: :json
    refute parsed_body['value']
    assert_response 200

    get failed_course_student_url(@my_course, @me, @float_test.id), as: :json
    refute parsed_body['value']
    assert_response 200
  end

  test "score for test returns correct result when i passed" do
    get score_for_course_student_url(@my_course, @me, @first_test), as: :json
    assert_equal 5, parsed_body['value']
    assert_response 200
  end

  test "score for test returns correct result when i failed" do
    get score_for_course_student_url(@my_course, @me, @second_test.id), as: :json
    assert_equal 4, parsed_body['value']
    assert_response 200
  end

  test "score for test returns correct result when i missed" do
    get score_for_course_student_url(@my_course, @me, @float_test.id), as: :json
    assert_equal '-', parsed_body['value']
    assert_response 200
  end
end
