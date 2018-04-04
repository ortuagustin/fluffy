class Course < ApplicationRecord
  include Contracts
  include CourseWithSearchableAssociations # /models/concerns/course_with_searchable_associations.rb

  has_many :students, dependent: :destroy
  has_many :tests, dependent: :destroy
  has_many :posts, dependent: :destroy

  validates_associated :students
  validates_associated :tests
  validates_associated :posts
  validates :year, presence: true
  validates :year, uniqueness: true
  validates :year, format: { with: /(19|20)\d{2}/i, message: :invalid_course_year }

  def attendants_for(test)
    students.select { |each| each.attended_to? test }.count
  end

  Contract Num => Student
  def student(student_id)
    students.detect { |each| each.id == student_id } || students.raise_record_not_found_exception!(student_id)
  end

  Contract String => Student
  def student(student_id)
    student(student_id.to_i)
  end

  Contract Num => Test
  def test(test_id)
    tests.detect { |each| each.id == test_id } || tests.raise_record_not_found_exception!(test_id)
  end

  Contract String => Test
  def test(test_id)
    test(test_id.to_i)
  end

  def passed_count
    students.select { |each| each.passed?(self) }.count
  end

  Contract Num => Post
  def post(post_id)
    posts.detect { |each| each.id == post_id } || posts.raise_record_not_found_exception!(post_id)
  end

  Contract String => Post
  def post(post_id)
    post(post_id.to_i)
  end
end
