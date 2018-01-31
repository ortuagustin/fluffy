class TestsController < ApplicationController
  before_action :set_test, only: [:edit, :update, :destroy]
  helper_method :course_id, :course, :courses, :start_year

  # GET /courses/:course_id/tests
  def index
    @tests = Test.from_course_id(course_id)
  end

  # GET /courses/:course_id/tests/new
  def new
    @test = Test.new
    @test.evaluated_at = Time.current
    @test.evaluated_at.year = course.year
  end

  # GET /courses/:course_id/tests/:test_id/edit
  def edit
  end

  # POST /courses/:course_id/tests
  def create
    @test = Test.new(test_params)
    die
    if @test.save
      redirect_to course_tests_path(course_id), notice: 'Test was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /courses/:course_id/tests/:test_id
  def update
    if @test.update(test_params)
      redirect_to course_tests_path(course_id), notice: 'Test was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /courses/:course_id/tests/:test_id
  def destroy
    @test.destroy
    redirect_to course_tests_path(course_id), notice: 'Test was successfully destroyed.'
  end
private
  def start_year
    Date.current.year
  end

  def courses
    @courses ||= Course.all
  end

  def course
    @course ||= Course.find(course_id)
  end

  def course_id
    course_params.require(:course_id)
  end

  def test_id
    params.require(:id)
  end

  def set_test
    @test = course.test(test_id)
  end

  def course_params
    params.permit(:course_id)
  end

  def test_params
    params.require(:test).permit(:title, :evaluated_at, :passing_score,).merge(course_params)
  end
end