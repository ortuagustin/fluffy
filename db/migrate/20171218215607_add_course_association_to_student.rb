class AddCourseAssociationToStudent < ActiveRecord::Migration[5.1]
  def change
    add_reference :students, :course, foreign_key: true
  end
end
