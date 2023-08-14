# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
subscription_plans_data = [
  { subscription_plan_name: 'expert', rajorpay_plan_id: 'plan_MP3QPB7uyNk6bt', daily_view_limit: 10, amount: 1000 },
  { subscription_plan_name: 'intermediate', rajorpay_plan_id: 'plan_MP3PfccTRCL8dF', daily_view_limit: 5, amount: 500 },
  { subscription_plan_name: 'beginner', rajorpay_plan_id: 'plan_MP3P7Am0H5z6Yl', daily_view_limit: 3, amount: 100 }
]

subscription_plans_data.each do |plan_data|
  SubscriptionPlan.create!(plan_data)
end