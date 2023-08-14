class AddUniqueIndexToViews < ActiveRecord::Migration[7.0]
  def change
    add_index :Views, [:user_id, :post_id], unique: true
  end
end
