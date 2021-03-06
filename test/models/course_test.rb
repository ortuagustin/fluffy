require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  setup do
    @current_course = courses(:current_course)
    @prior_course = courses(:prior_course)
    @me = students(:me)
    @first_test = tests(:first_test)
  end

  test "should not accept a blank year" do
    course = Course.new(year: '')
    assert course.invalid?
  end

  test "should not accept a nil year" do
    course = Course.new(year: nil)
    assert course.invalid?
  end

  test "should not accept invalid formatted year" do
    course = Course.new(year: 12)
    assert course.invalid?
    course = Course.new(year: 123)
    assert course.invalid?
    course = Course.new(year: 1234)
    assert course.invalid?
    course = Course.new(year: 12345)
    assert course.invalid?

    course = Course.new(year: 19)
    assert course.invalid?
    course = Course.new(year: 191)
    assert course.invalid?
    course = Course.new(year: 20)
    assert course.invalid?
    course = Course.new(year: 201)
    assert course.invalid?
  end

  test "should accept correctly formatted year" do
    course = Course.new(year: 1900)
    assert course.valid?
    course = Course.new(year: 2000)
    assert course.valid?
    course = Course.new(year: 2010)
    assert course.valid?
  end

  test "should not accept duplicated year" do
    course = Course.new(year: 2000)
    assert course.save
    same_course = Course.new(year: 2000)
    assert_not same_course.save
  end

  test "current_course should have me as student" do
    assert @current_course.students.include?(@me)
  end

  test "prior_course should not have me as student" do
    assert_not @prior_course.students.include?(@me)
  end

  test "deleting a course should delete associated students" do
    course_id = @current_course.id
    @current_course.destroy
    students = Student.where(course_id: course_id)
    assert students.empty?
  end

  test "deleting a course should delete associated tests" do
    course_id = @current_course.id
    @current_course.destroy
    tests = Test.where(course_id: course_id)
    assert tests.empty?
  end

  test "it returns correct student when the given student id belongs to the course" do
    course = courses(:foo_course)
    actual = course.student 1
    expected = students(:student_with_id_1)
    assert_equal expected, actual
  end

  test "it returns correct student even if the given student id is passed as string" do
    course = courses(:foo_course)
    actual = course.student '1'
    expected = students(:student_with_id_1)
    assert_equal expected, actual
  end

  test "it raises exception when the given student id doest not exist in the course" do
    assert_raises(ActiveRecord::RecordNotFound) do
      courses(:foo_course).student 12345
    end
  end

  test "it returns correct test when the given test id belongs to the course" do
    course = courses(:foo_course)
    actual = course.test 1
    expected = tests(:test_with_id_1)
    assert_equal expected, actual
  end

  test "it returns correct test even if the given test id is passed as string" do
    course = courses(:foo_course)
    actual = course.test '1'
    expected = tests(:test_with_id_1)
    assert_equal expected, actual
  end

  test "it raises exception when the given test id doest not exist in the course" do
    assert_raises(ActiveRecord::RecordNotFound) do
      courses(:foo_course).test 12345
    end
  end

  test "it has may posts associated" do
    assert_equal 0, @current_course.posts.size
    assert_equal 2, courses(:foo_course).posts.size
  end

  test "posts should be ordered from most recent" do
    recent_post = Post.create(title: 'recent', body: 'recent', user: User.first, created_at: 5.days.ago)
    old_post = Post.create(title: 'old', body: 'old', user: User.first, created_at: 15.days.ago)
    @current_course.posts << old_post
    @current_course.posts << recent_post

    assert_equal recent_post, @current_course.posts.first
    assert_equal old_post, @current_course.posts.second
  end

  test "it returns the most recently updated posts in correct order" do
    5.times do |i|
      @current_course.posts << Post.create(title: "test #{i}", body: "test #{i}", user: User.first, updated_at: i.days.ago)
    end

    most_recently_updated = @current_course.posts.third
    most_recently_updated.touch

    assert_equal most_recently_updated, @current_course.most_recently_updated_posts.first
  end

  test "it returns the most popular posts in correct order" do
    5.times do |i|
      @current_course.posts << Post.create(title: "test #{i}", body: "test #{i}", user: User.first)
    end

    most_popular = @current_course.posts.third
    most_popular.replies << Reply.create(body: 'test', user: User.first)

    assert_equal most_popular, @current_course.most_popular_posts.first
  end

  test "it returns the most liked posts in correct order" do
    5.times do |i|
      @current_course.posts << Post.create(title: "test #{i}", body: "test #{i}", user: User.first)
    end

    most_liked = @current_course.posts.third
    most_liked.liked_by User.first

    assert_equal most_liked, @current_course.most_liked_posts.first
  end

  test "most liked posts does not include post without likes" do
    5.times do |i|
      @current_course.posts << Post.create(title: "test #{i}", body: "test #{i}", user: User.first)
    end

    most_liked = @current_course.posts.third
    most_liked.liked_by User.first

    assert_equal 1, @current_course.most_liked_posts.size
  end

  test "sticky posts should take priority when ordering" do
    recent_post = Post.create(title: 'recent', body: 'recent', user: User.first, created_at: 5.days.ago)
    old_post = Post.create(title: 'old', body: 'old', user: User.first, created_at: 15.days.ago)
    most_old_post_but_sticky = Post.create(is_sticky: true, title: 'sticky', body: 'sticky', user: User.first, created_at: 30.days.ago)
    @current_course.posts << old_post
    @current_course.posts << most_old_post_but_sticky
    @current_course.posts << recent_post

    assert_equal most_old_post_but_sticky, @current_course.posts.first
    assert_equal recent_post, @current_course.posts.second
    assert_equal old_post, @current_course.posts.third
  end

  test "it returns correct post when the given post id belongs to the course" do
    course = courses(:foo_course)
    actual = course.post 1
    expected = posts(:one)
    assert_equal expected, actual
  end

  test "it returns correct post even if the given post id is passed as string" do
    course = courses(:foo_course)
    actual = course.post '1'
    expected = posts(:one)
    assert_equal expected, actual
  end

  test "it raises exception when the given post id doest not exist in the course" do
    assert_raises(ActiveRecord::RecordNotFound) do
      courses(:foo_course).post 12345
    end
  end

  test "deleting a course should delete associated posts" do
    course_id = @current_course.id
    @current_course.destroy
    posts = Post.where(course_id: course_id)
    assert posts.empty?
  end
end