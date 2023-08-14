class SubscriptionsController < ApplicationController
    before_action :authenticate_user, except: [:index]
    def index
        render json: SubscriptionPlan.all
    end
    def create
        @subscription = Subscription.create(user_id: @current_user.id, 
                                            subscription_plan_id: get_plan_id_from_subscription_plans(params[:plan_id]), 
                                            rajorpay_subscription_id: params[:id] )
        if @subscription
            render json: { response: @subscription, message: 'Subscribed' }, status: :created
        else
            render json: { message: 'something went wrong' }, status: :unprocessable_entity
        end
    end
    def redirect_to_payments
        redirect_to payments_create_path(id: params[:plan_id])
    end

    private
    def id
        params.permit(:plan_id)
    end
    def get_plan_id_from_subscription_plans(plan_id)
        SubscriptionPlan.find_by(rajorpay_plan_id: plan_id).id
    end
end
