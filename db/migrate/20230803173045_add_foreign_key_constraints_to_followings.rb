class AddForeignKeyConstraintsToFollowings < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :followings, :users, column: :follower_id, on_delete: :cascade
    add_foreign_key :followings, :users, column: :followed_id, on_delete: :cascade
  end
end
