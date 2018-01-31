class TestsController < ApplicationController
  before_action :set_test, only: [:show, :edit, :update, :destroy]
  helper_method :course_id, :course, :courses, :start_year

  # GET /courses/:course_id/tests
  def index
    @tests = Test.from_course_id(course_id)
  end

  # GET /courses/:course_id/tests/:test_id
  def show
  end

  # GET /courses/:course_id/tests/new
  def new
    @test = Test.new(course_id: course_id)
    @test.evaluated_at_date = Date.current
    @test.evaluated_at_time = Time.current.utc
  end

  # GET /courses/:course_id/tests/:test_id/edit
  def edit
    @test.evaluated_at_date = Date.parse(@test.evaluated_at)
    @test.evaluated_at_time = Time.parse(@test.evaluated_at)
  end

  # POST /courses/:course_id/tests
  def create
    @test = Test.new(test_params)
    if @test.save
      redirect_to course_test_path(course_id, @test), notice: 'Test was successfully created.'
    else
      check_evaluated_at_validation
      render :new
    end
  end

  # PATCH/PUT /courses/:course_id/tests/:test_id
  def update
    if @test.update(test_params)
      redirect_to course_test_path(course_id, @test), notice: 'Test was successfully updated.'
    else
      check_evaluated_at_validation
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
    p = params.require(:test).permit(:evaluated_at_date, :evaluated_at_time, :title, :passing_score)
    p[:evaluated_at] = parse_evaluated_date(p)
    p[:course_id] = course_id.to_i
    p.except(:evaluated_at_date, :evaluated_at_time).permit(:title, :evaluated_at, :passing_score, :course_id)
  end

  def parse_evaluated_date(p)
    DateTime.parse(p[:evaluated_at_date] + ' ' + p[:evaluated_at_time])
  rescue ArgumentError
    ''
  end

  def check_evaluated_at_validation
    if @test.errors[:evaluated_at].present?
      @test.errors[:evaluated_at_date] << @test.errors[:evaluated_at]
    end
  end
end