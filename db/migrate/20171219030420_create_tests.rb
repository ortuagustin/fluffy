class CreateTests < ActiveRecord::Migration[5.1]
  def change
    create_table :tests do |t|
      t.string :title
      t.datetime :evaluated_at
      t.integer :passing_score
      t.references :course, foreign_key: true

      t.timestamps
    end
  end
end
