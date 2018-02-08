class CoursesController < ApplicationController
  include SortsModels
  include FiltersModels

  before_action :set_colours
  before_action :set_course, only: [:destroy]
  before_action :fetch_all_courses, only: [:index, :create]
  helper_method :tile_class, :min_year, :max_year

  # GET /courses
  def index
    @new_course = Course.new(year: Date.current.year)
  end

  # GET /courses/:id
  def show
    redirect_to course_students_path(course_id)
  end

  # POST /courses
  def create
    @course = Course.new(course_params)

    if @course.save
      redirect_to @course, notice: (t 'courses.flash.created')
    else
      render :index
    end
  end

  # DELETE /courses/:id
  def destroy
    @course = Course.find(params[:id])
    @course.destroy
    redirect_to courses_url, notice: (t 'courses.flash.deleted')
  end
private
  def set_colours
    @colours = ['success', 'warning', 'danger', 'info', 'link']
  end

  def random_colour(index)
    @colours.shuffle[index]
  end

  def colour(index)
    random_colour(index % @colours.size)
  end

  def tile_class(index)
    "'tile is-child box notification has-text-centered is-#{colour(index)}'".html_safe
  end

  def fetch_all_courses
    @courses = Course.order(year: :desc)
  end

  def course_id
    params.require(:id)
  end

  def course_params
    params.require(:course).permit(:year)
  end

  def min_year
    2.years.ago.year
  end

  def max_year
    5.years.since.year
  end
end
