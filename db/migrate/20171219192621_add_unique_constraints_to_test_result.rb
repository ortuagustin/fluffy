class AddUniqueConstraintsToTestResult < ActiveRecord::Migration[5.1]
  def change
    change_table :test_results do |t|
      t.index [:test_id, :student_id], unique: true
    end
  end
end
