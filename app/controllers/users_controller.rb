class UsersController < ApplicationController
    skip_before_action :authenticate_user, only: [:create, :login]
    include UsersHelper

    def create
        begin
            if check_user_already_exist    
                render json: { errors: 'user already exist' }, status: :bad_request 
            else
                @user  = User.new(user_params)
                customer_id = create_rajorpay_customer
                if customer_id
                    @user.customer_id = customer_id
                    @user.save
                    render json: {user: @user.as_json(except: [:password_digest])}, status: :created
                end
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error 
        end
    end

    def update
        unless @user.update(user_params)
            render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @user.destroy
    end

    def login
        begin        
            @user = User.find_by(email: params[:email])
            if @user&.authenticate(params[:password])
                token = generate_jwt_token()
                render json: { token: token, message: "login successful" }, status: :ok
            else
                render json: { error: 'Invalid credentials' }, status: :unauthorized
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    
    def show
        begin
            @user = User.find(params[:id])
            if @user
                render  json: { user: @user.as_json(except: [:password_digest]), posts: post_by_user }, status: :ok
            else
                render  json: { message: "user not found" }, status: :not_found
            end
        rescue => e
            render  json: { error: e.message }, status: :internal_server_error 
        end
    end

    private
    def user_params
        params.permit(:username, :email, :password)
    end

    def check_user_already_exist
        User.where("username = :username OR email = :email", username: params[:username], email: params[:email]).first
    end

    def post_by_user
        @user.posts.order(created_at: :desc).limit(5)
    end

    def create_rajorpay_customer
        customer = Razorpay:: Customer.create(email: @user.email, name: @user.username)
        customer.id
    end
end