class TestResultsController < ApplicationController

  # GET /courses/:course_id/tests/:test_id/results
  def show
    @course = Course.find(course_id)
    @test = @course.test(test_id)
    @students = Student.from_course_id(course_id)
  end

private
  def course_id
    course_params.require(:course_id)
  end

  def test_id
    params.require(:id)
  end

  def course_params
    params.permit(:course_id)
  end
end