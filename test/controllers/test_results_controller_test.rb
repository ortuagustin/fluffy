require 'test_helper'

class TestResultsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:current_course)
    @student = students(:me)
    @test_result = test_results(:my_first_test_result)
  end

  test "should get index" do
    get course_student_test_results_url(@course, @student), as: :json
    assert_response :success
  end

  test "should create test_result" do
    float_test = tests(:float_test)
    assert_difference('@student.test_results.count') do
      post course_student_test_results_url(@course, @student), params: {
        test_result: {
          score: @test_result.score, student_id: @student.id, test_id: float_test.id
        } }, as: :json
    end

    assert_response 201
  end

  test "should show test_result" do
    get course_student_test_result_url(@course, @student, @test_result), as: :json
    assert_response :success
  end

  test "should update test_result" do
    patch course_student_test_result_url(@course, @student, @test_result), params: {
      test_result: {
        score: @test_result.score, student_id: @test_result.student_id, test_id: @test_result.test_id
      } }, as: :json

    assert_response 200
  end

  test "should destroy test_result" do
    assert_difference('@student.test_results.count', -1) do
      delete course_student_test_result_url(@course, @student, @test_result), as: :json
    end

    assert_response 204
  end
end
