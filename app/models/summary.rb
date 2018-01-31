module Summary
  class CourseSummary
    attr_reader :course
    delegate :empty?, :count, to: :tests
    alias_method :test_count, :count

    def initialize(course)
      @course = course
    end

    def tests
      course.tests.order(evaluated_at: :desc)
    end
  end

  module TestSummary
    def passed_count
      results.select { |each| each.passed? }.count
    end

    def failed_count
      results.select { |each| each.failed? }.count
    end

    def attended_count
      course.attendants_for self
    end

    def missing_count
      course.students_count - attended_count
    end

    def passed_average
      return 0 if attended_count.zero?
      passed_count.fdiv attended_count
    end

    def passed_average_percentage
      (passed_average * 100).to_s(:percentage, precision: 2)
    end
  end
end
