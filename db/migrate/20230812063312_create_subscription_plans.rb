class CreateSubscriptionPlans < ActiveRecord::Migration[7.0]
  def change
    add_column :subscription_plans, :subscription_plan_name, :string
    add_column :subscription_plans, :rajorpay_plan_id, :string
    add_column :subscription_plans, :daily_view_limit, :integer
  end
end
