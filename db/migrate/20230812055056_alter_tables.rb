class AlterTables < ActiveRecord::Migration[7.0]
  def change
    create_table :subscription_plans do |t|
    end
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true, on_delete: :cascade
      t.references :plan, null: false, foreign_key: true, on_delete: :cascade
      t.string :rajorpay_subscription_id

      t.timestamps
    end
    add_column :users, :customer_id, :string
    remove_column :users, :daily_limit, :integer
  end
end
