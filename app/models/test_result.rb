class TestResult < ApplicationRecord
  Test.include Summary::TestSummary

  belongs_to :test
  belongs_to :student
  delegate :passing_score, to: :test
  validates :score, presence: :true, inclusion: { in: 1..10 }
  validates :student_id, uniqueness: { scope: :test_id, message: :duplicated_test_result }

  def passed?
    score >= passing_score
  end

  def failed?
    !passed?
  end
end
