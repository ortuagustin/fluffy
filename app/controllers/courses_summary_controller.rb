class CoursesSummaryController < ApplicationController
  include SortsModels
  include FiltersModels

  sorts :students, :surname, :name, :surname, :dni, :email, :file_number
  before_action :set_course

  # GET /courses/:id/summary
  def show
    @tests = @course.tests
    @students = @course.students({ order: students_sort_params, keyword: filter }).page(params[:page])
  end
private
  def set_course
    @course = Course.find(params[:id])
  end

  def sortable_columns
    %w[name surname dni email file_number]
  end

  def default_sort_column
    'surname'
  end
end