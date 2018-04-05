require 'faker'

# delete all users
User.destroy_all

# create admin user
admin = User.create(:username => 'admin', :password => 'admin', :email => 'admin@test.com')

# empty database
Course.destroy_all

ActiveRecord::Base.transaction do
  # create courses
  last_course = Course.create(year: 2016)
  current_course = Course.create(year: 2017)

  # add test to courses
  10.times do |i|
    course = (i.odd? ? last_course : current_course)
    course.tests <<
      Test.create(title: Faker::ProgrammingLanguage.name,
                  evaluated_at: Faker::Time.between(Date.current.beginning_of_year, Date.current.end_of_year).change(year: course.year),
                  passing_score: Faker::Number.between(1, 10))
  end

  # create some students and some results
  100.times do |i|
    student = Student.create(name: Faker::HarryPotter.unique.character,
                             surname: Faker::HarryPotter.house,
                             dni: Faker::Number.unique.number(8),
                             file_number: "#{Faker::Number.unique.number(5)}/#{Faker::Number.number(1)}",
                             email: Faker::Internet.unique.email)

    course = (i.odd? ? last_course : current_course)
    course.students << student
    course.tests.each_with_index do |test, i|
      unless student.id.multiple_of? 5
        student.test_results << TestResult.create(test: test, score: Faker::Number.between(1, 10))
      end
    end
  end

  # create some posts with some replies
  Faker::Number.between(50, 150).times do |i|
    course = (i.odd? ? last_course : current_course)
    post = Post.create(title: Faker::Lorem.sentence,
                       body: Faker::Lorem.paragraph,
                       user: admin)

    course.posts << post

    Faker::Number.between(10, 50).times do |j|
      post.replies << Reply.create(body: Faker::Lorem.paragraph, user: admin)
    end
  end
end
