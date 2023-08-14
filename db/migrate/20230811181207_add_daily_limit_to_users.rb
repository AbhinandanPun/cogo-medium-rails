class AddDailyLimitToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :daily_limit, :integer
    
    remove_foreign_key :lists, :users
    add_foreign_key :lists, :users, on_delete: :cascade
  end
end
