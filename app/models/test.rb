class Test < ApplicationRecord
  include Summary::TestSummary

  belongs_to :course
  has_many :test_results, dependent: :destroy

  alias_attribute :results, :test_results

  validates :title, :evaluated_at, presence: true
  validates :title, length: { maximum: 255 }
  validates :passing_score, inclusion: { in: 1..10 }
  validate :test_date_cannot_be_in_the_past

  def save_test_results(califications)
    Test.transaction do
      califications.each do |student_id, score|
        return false unless process_calification(student_id, score)
      end
    end

    true
  end

private
  def process_calification(student_id, score)
    if score != '-'
      save_calification(student_id, score)
    else
      destroy_calification(student_id)
    end
  end

  def save_calification(student_id, score)
    result = test_results.find_or_initialize_by(student_id: student_id)
    result.score = score
    result.save
  end

  def destroy_calification(student_id)
    test_results.where(:student_id => student_id).delete_all
  end

  def test_date_cannot_be_in_the_past
    return if evaluated_at.blank? || course.try(:year).blank?
    if evaluated_at.year < course.year
      errors[:evaluated_at] << I18n.translate('activerecord.errors.messages.test_date_already_passed', value: evaluated_at)
    end
  end
end
