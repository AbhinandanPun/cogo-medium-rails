class ChangeForeignKeyOnPosts < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :posts, :users
    add_foreign_key :posts, :users, on_delete: :cascade
  end
end
