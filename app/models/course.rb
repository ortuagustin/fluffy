class Course < ApplicationRecord
  include Contracts
  include CourseWithSearchableAssociations # /models/concerns/course_with_searchable_associations.rb
  include GeneratesUrls                    # /models/concerns/generates_urls.rb

  has_many :students, dependent: :destroy
  has_many :tests, dependent: :destroy
  has_many :posts, -> { order(is_sticky: :desc, created_at: :desc) }, dependent: :destroy

  validates_associated :students
  validates_associated :tests
  validates_associated :posts
  validates :year, presence: true
  validates :year, uniqueness: true
  validates :year, format: { with: /(19|20)\d{2}/i, message: :invalid_course_year }

  def most_recently_updated_posts(limit = nil)
    posts_trending_by(:updated_at, :desc, limit)
  end

  def most_popular_posts(limit = nil)
    posts_trending_by(:replies_count, :desc, limit)
  end

  def most_liked_posts(limit = nil)
    most_liked = posts
      .unscoped
      .sort_by { |post| -post.like_score }
      .select { |post| post.like_score > 0 }

    return most_liked unless limit.present?

    most_liked.first(limit)
  end

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

  def forum_path
    course_posts_path(course_id: id)
  end

  def add_post_path
    new_course_post_path(course_id: id)
  end
private
  def posts_trending_by(field, direction, limit = nil)
    trending = posts.reorder(field => direction)

    return trending unless limit.present?

    trending.limit(limit)
  end
end
