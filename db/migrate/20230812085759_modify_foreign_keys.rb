class ModifyForeignKeys < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :revision_histories, :users
    add_foreign_key :revision_histories, :users, on_delete: :cascade
  end
end
