class Student < ApplicationRecord
  include Contracts
  belongs_to :course, counter_cache: true
  has_many :test_results, dependent: :destroy
  has_many :tests, through: :test_results

  default_scope { includes(:tests, :test_results) }

  validates :name, :surname, :email, :file_number, :dni, presence: true
  validates :name, :surname, :email, length: { maximum: 255 }
  validates :file_number, length: { maximum: 7 }
  validates :dni, length: { in: 7..8 }
  validates :dni, numericality: { only_integer: true }
  validates :email, email: { message: :invalid_email }
  validates :dni, uniqueness: { scope: :course_id, message: :already_belongs_to_course }
  validates :id, uniqueness: { scope: :course_id, message: :already_belongs_to_course }
  validates :file_number, uniqueness: { scope: :course_id, message: :already_belongs_to_course }

  Contract Num => Bool
  def attended_to?(test_id)
    attended_to?(Test.find_by_id test_id)
  end

  Contract Any => Bool
  def attended_to?(test)
    tests.include? test
  end

  def missed?(test)
    !attended_to? test
  end

  Contract Or[Num, Test] => Bool
  def passed?(test)
    attended_to?(test) ? result_for(test).passed? : false
  end

  Contract Or[Num, Test] => Bool
  def failed?(test)
    attended_to?(test) ? result_for(test).failed? : false
  end

  def score_for(test)
    attended_to?(test) ? result_for(test).score : '-'
  end

  Contract Course => Bool
  def passed?(course)
    course.tests.all? { |test| passed? test }
  end

  Contract Course => Bool
  def failed?(course)
    course.tests.any? { |test| failed? test }
  end
private
  Contract Num => TestResult
  def result_for(test_id)
    test_results.detect { |each| each.test_id == test_id }
  end

  Contract Test => TestResult
  def result_for(test)
    result_for(test.id)
  end
end
