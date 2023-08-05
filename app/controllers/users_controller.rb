class UsersController < ApplicationController
    skip_before_action :authenticate_user, except: [:history]
    skip_before_action :verify_authenticity_token

    include UsersHelper
    
    def show
        begin
            user = User.find_by(username: params[:username])
            if user
                post = Post.where(user: user)
                render json: {user: user.as_json(except: [:password_digest, :created_at, :updated_at]), post: post}, status: :ok
            else
                render json: {errors: "user not found"}, status: :not_found
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error 
        end
    end
    def signup
        begin
            valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
            valid_regex = /^[^\s]{8,}$/
            if !(params[:username] =~ valid_regex) || !(params[:email] =~valid_email_regex) || !(params[:password] =~ valid_regex)
                render json: { errors: "Credentials wrong, 8 character password and username without space ,with proper email"}, status: :unprocessable_entity
            else
                user = User.find_by('username = :username OR email = :email', username: params[:username], email: params[:email])
                if user 
                    render json: { errors: "Either username or email already in use"}, status: :bad_request 
                else
                    user = User.create(username: params[:username], email: params[:email], password: params[:password])
                    if user
                        render json: user.as_json(except: [:password_digest, :created_at, :updated_at]), status: :created
                    end
                end
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error 
        end
    end
    def login
        begin        
            user = User.find_by(email: params[:email])
            if user&.authenticate(params[:password])
              token = generate_jwt_token(user)
              render json: { token: token, message: "login successful" }, status: :ok
            else
                render json: { error: 'Invalid credentials' }, status: :unauthorized
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    def history
        @user_interactions = @current_user.interaction_histories.includes(:post)
        response = @user_interactions.map do |interaction|
          {
            username: interaction.user.username,
            interaction_type: interaction.interaction_type,
            post_id: interaction.post_id,
            post_title: interaction.post.title,
            post_topic: interaction.post.topic,
            date: interaction.created_at.strftime("%Y-%m-%d"),
            time: interaction.created_at.strftime("%H:%M:%S")
          }
        end
        render json: response, status: :ok
    end
end