class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.integer :user_id, null: false
      t.integer :subscription_plan_id, null: false
      t.string :rajorpay_subscription_id
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false

      t.index [:user_id], unique: true
      t.foreign_key :users, column: :user_id, on_delete: :cascade
    end
  end
end
