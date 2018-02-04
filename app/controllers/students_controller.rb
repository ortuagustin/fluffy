class StudentsController < ApplicationController
  before_action :set_student, except: [:index, :create, :new]
  helper_method :course_id, :course, :courses

  # GET /courses/:course_id/students
  def index
    @students = course.students.page(params[:page])
  end

  # GET /courses/:course_id/students/new
  def new
    @student = Student.new
  end

  # POST /courses/:course_id/students
  def create
    @student = Student.new(student_params)

    if @student.save
      redirect_to course_students_url(@student.course_id, @student), notice: 'Student was successfully created.'
    else
      render :new
    end
  end

  # GET /courses/:course_id/students/:student_id/edit
  def edit
  end

  # PATCH/PUT /courses/:course_id/students/:student_id
  def update
    if @student.update(student_params)
      redirect_to course_students_url(@student.course_id, @student), notice: 'Student was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /courses/:course_id/students/:student_id
  def destroy
    @student.destroy
    redirect_to course_students_url(@student.course_id, @student), notice: 'Student was successfully destroyed.'
  end
private
  def courses
    @courses ||= Course.all
  end

  def course
    @course ||= Course.find(course_id)
  end

  def course_id
    course_params.require(:course_id)
  end

  def student_id
    params.require(:id)
  end

  def set_student
    @student = course.student(student_id)
  end

  def course_params
    params.permit(:course_id)
  end

  def student_params
    params.require(:student).permit(:name, :surname, :dni, :email, :file_number).merge(course_params)
  end
end