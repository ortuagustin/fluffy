class AddStudentsCountToCourses < ActiveRecord::Migration[5.1]
  def change
    change_table :courses do |t|
      t.integer :students_count, default: 0
    end

    Course.reset_column_information
    Course.all.each { |c| Course.reset_counters(c.id, :students) }
  end
end
