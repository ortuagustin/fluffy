class AddSlugToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :slug, :string
    add_index :posts, :slug, unique: true

    Post.find_each(&:save)
  end
end
