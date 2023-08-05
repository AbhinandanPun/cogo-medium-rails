class RemoveImageFromDrafts < ActiveRecord::Migration[7.0]
  def change
    remove_column :drafts, :image, :string
  end
end
