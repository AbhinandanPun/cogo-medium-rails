class PaymentsController < ApplicationController
    before_action :authenticate_user
    def create
        @order =  create_razorpay_order( params[:id] )
        return @order
    end
    
    def success
        if payment_successful?(params[:order_id], params[:payment_id])
            @subscription = create_subscription(params[:plan_id])
            # puts @subscription
            redirect_to subscriptions_create_path(id: @subscription.id, plan_id: @subscription.plan_id)
        else
            render json: { message: "Some problem with payment" }, status: :bad_request
        end
    end
    
    def failure
        render json: { message: "Payment failed" }, status: :bad_request
    end
    
    private
    def create_razorpay_order( plan_id )
        plan = Razorpay:: Plan.fetch( plan_id ).item
        order_params = {
          amount: plan['amount'], 
          currency: plan['currency'],
          receipt: 'order_receipt',
          notes: { plan_id: plan_id }
        }
        Razorpay:: Order.create(order_params)
    end
    
    def payment_successful?(order_id, payment_id)
        payment = Razorpay:: Payment.fetch(payment_id)
        payment.order_id == order_id && payment.status == 'captured'
    end
    
    def create_subscription(plan_id)
        customer_id = @current_user.customer_id
        subscription = Razorpay:: Subscription.create(
          plan_id: plan_id,
          customer_id: customer_id, # 5 minutes as time.now < rajorpay_system_time when req gets there, was showing
          total_count: 1,
          expire_by: (1.month.from_now).to_i
        )
        subscription 
    end
end