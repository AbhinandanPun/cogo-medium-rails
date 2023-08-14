class SetDefaultDailyLimitForUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :daily_limit, 1
  end
end
