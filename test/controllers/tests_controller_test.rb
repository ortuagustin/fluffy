require 'test_helper'

class TestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @first_test = tests(:first_test)
    @current_course = courses(:current_course)
  end

  test "should get index" do
    get course_tests_url(@current_course), as: :json
    assert_response :success
  end

  test "should create test" do
    assert_difference('@current_course.tests.count') do
      post course_tests_url(@current_course), params: {
        test: {
          course_id: @first_test.course_id, evaluated_at: @first_test.evaluated_at,
          passing_score: @first_test.passing_score, title: @first_test.title }
        }, as: :json
    end

    assert_response 201
  end

  test "should show test" do
    get course_test_url(@current_course, @first_test), as: :json
    assert_response :success
  end

  test "should update test" do
    patch course_test_url(@current_course, @first_test), params: {
      test: {
        course_id: @first_test.course_id, evaluated_at: @first_test.evaluated_at,
        passing_score: @first_test.passing_score, title: @first_test.title }
      }, as: :json
    assert_response 200
  end

  test "should destroy test" do
    assert_difference('@current_course.tests.count', -1) do
      delete course_test_url(@current_course, @first_test), as: :json
    end

    assert_response 204
  end
end
