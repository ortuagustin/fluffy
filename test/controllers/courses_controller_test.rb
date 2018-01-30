require 'test_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:current_course)
  end

  test "should get index" do
    get courses_url, as: :json
    assert_response :success
  end

  test "should create course" do
    assert_difference('Course.count') do
      post courses_url, params: { course: { year: 2018 } }, as: :json
    end

    assert_response 201
  end

  test "should show course" do
    get course_url(@course), as: :json
    assert_response :success
  end

  test "should update course" do
    patch course_url(@course), params: { course: { year: 2015 } }, as: :json
    assert_response 200
  end

  test "should destroy course" do
    assert_difference('Course.count', -1) do
      delete course_url(@course), as: :json
    end

    assert_response 204
  end

  test "should return course summary" do
    get course_summary_url(@course), as: :json
    assert_response :success
    assert_not parsed_body.blank?
  end
end
