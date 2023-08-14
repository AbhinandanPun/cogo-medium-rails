class RemoveSubscriptions < ActiveRecord::Migration[7.0]
  def up
    drop_table :subscriptions
  end

  def down
    create_table "subscriptions", force: :cascade do |t|
      t.integer "user_id", null: false
      t.integer "plan_id", null: false
      t.string "rajorpay_subscription_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["plan_id"], name: "index_subscriptions_on_plan_id"
      t.index ["user_id"], name: "index_subscriptions_on_user_id"
    end
  end
end