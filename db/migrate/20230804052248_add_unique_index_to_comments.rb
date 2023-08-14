class AddUniqueIndexToComments < ActiveRecord::Migration[7.0]
  def change
    add_index :Comments, [:user_id, :post_id], unique: true
  end
end
