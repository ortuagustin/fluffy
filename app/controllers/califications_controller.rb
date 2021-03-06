class CalificationsController < ApplicationController
  include SortsModels # app/controllers/concerns/sorts_models.rb
  include FiltersModels

  sorts :students, :surname, :name, :dni, :email, :file_number

  before_action :fetch_course
  before_action :fetch_test
  before_action :fetch_students

  # GET /courses/:course_id/tests/:test_id/califications
  def show
  end

  # GET /courses/:course_id/tests/:test_id/edit_califications
  def edit
  end

  # PATCH/PUT /courses/:course_id/tests/:test_id/califications
  def update
    if @test.save_test_results(students_with_scores)
      redirect_to califications_course_test_path(course_id, test_id), notice: (t 'test_results.flash.stored_successfully')
    else
      redirect_to edit_califications_course_test_path(course_id, test_id), alert: (t 'test_results.flash.store_failed')
    end
  end
private
  def fetch_course
    @course = Course.find(course_id)
  end

  def fetch_test
    @test = @course.test(test_id)
  end

  def fetch_students
    @students = @course.students({ order: students_sort_params, keyword: filter }).page(params[:page])
  end

  def course_id
    course_params.require(:course_id)
  end

  def test_id
    params.require(:id)
  end

  def course_params
    params.permit(:course_id)
  end

  def scores
    params.require(:scores)
  end

  def students
    params.require(:students)
  end

  def students_with_scores
    Hash[students.zip scores]
  end
end