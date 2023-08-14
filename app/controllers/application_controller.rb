class ApplicationController < ActionController::Base
    before_action :authenticate_user
    skip_before_action :verify_authenticity_token

    def authenticate_user
        token = request.headers['Authorization']&.split(' ')&.last
        begin
        decoded_token = JWT.decode(token, jwt_secret_key, true, algorithm: 'HS256')
        user_id = decoded_token.first['user_id']
        @current_user = User.find(user_id)
        
        rescue JWT::ExpiredSignature
            render json: { error: 'Token has expired' }, status: :unauthorized

        rescue JWT::DecodeError, ActiveRecord::RecordNotFound
            render json: { error: 'Invalid token' }, status: :unauthorized
        end
    end
    
    private
    def jwt_secret_key
        Rails.application.secrets.jwt_secret_key
    end
end
