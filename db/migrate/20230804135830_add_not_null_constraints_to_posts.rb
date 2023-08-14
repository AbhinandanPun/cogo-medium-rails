class AddNotNullConstraintsToPosts < ActiveRecord::Migration[7.0]
  def change
    change_column_null :posts, :title, false
    change_column_null :posts, :topic, false
    change_column_null :posts, :text, false
  end
end
