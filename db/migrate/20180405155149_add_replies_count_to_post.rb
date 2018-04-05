class AddRepliesCountToPost < ActiveRecord::Migration[5.1]
  def change
    change_table :posts do |t|
      t.integer :replies_count, default: 0
    end

    Post.reset_column_information
    Post.all.each { |p| Post.reset_counters(p.id, :replies) }
  end
end
