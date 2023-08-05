class AddColumnsToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :read_time, :integer, default: 0
    add_column :posts, :like_count, :integer, default: 0
    add_column :posts, :comment_count, :integer, default: 0
    add_column :posts, :view_count, :integer, default: 0
  end
end
