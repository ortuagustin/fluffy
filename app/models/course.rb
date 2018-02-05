class Course < ApplicationRecord
  has_many :students, -> { order(:surname, :name) }, dependent: :destroy
  has_many :tests, -> { order('evaluated_at ASC') }, dependent: :destroy

  validates_associated :students
  validates_associated :tests
  validates :year, presence: true
  validates :year, uniqueness: true
  validates :year, format: { with: /(19|20)\d{2}/i, message: :invalid_course_year }

  def attendants_for(test)
    students.select { |each| each.attended_to? test }.count
  end

  def student(student_id)
    students.find(student_id)
  end

  def test(test_id)
    tests.find(test_id)
  end

  def passed_count
    students.select { |each| each.passed?(self) }.count
  end
end
