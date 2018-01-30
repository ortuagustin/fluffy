class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :destroy]
  before_action :fetch_courses, only: [:index, :create]

  # GET /courses
  # GET /courses.json
  def index
    @course = Course.new
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    redirect_to course_students_path(course_id)
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :index }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

private
  def set_course
    @course = Course.find(params[:id])
  end

  def fetch_courses
    @courses = Course.all
  end

  def course_params
    params.require(:course).permit(:year)
  end
end
