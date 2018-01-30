class CreateTestResults < ActiveRecord::Migration[5.1]
  def change
    create_table :test_results do |t|
      t.references :test, foreign_key: true
      t.references :student, foreign_key: true
      t.integer :score

      t.timestamps
    end
  end
end
