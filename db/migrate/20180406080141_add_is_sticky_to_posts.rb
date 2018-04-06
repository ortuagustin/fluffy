class AddIsStickyToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :is_sticky, :boolean, null: false, default: false
  end
end
