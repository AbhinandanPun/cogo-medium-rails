class ApplicationController < ActionController::Base
    before_action :authenticate_user
    include ApplicationHelper

    def authenticate_user
        token = request.headers['Authorization']&.split(' ')&.last
        begin
        decoded_token = JWT.decode(token, jwt_secret_key, true, algorithm: 'HS256')
        user_id = decoded_token.first['user_id']
        @current_user = User.find(user_id)
        rescue JWT::DecodeError, JWT::VerificationError, ActiveRecord::RecordNotFound
        render json: { error: 'Invalid or missing token' }, status: :unauthorized
        end
    end
    
end
