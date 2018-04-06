class AddBestReplyToPost < ActiveRecord::Migration[5.1]
  def change
    add_reference :posts, :best_reply, foreign_key: true, nullable: true, default: :null
  end
end
