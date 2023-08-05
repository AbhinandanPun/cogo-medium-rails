module UsersHelper
    def generate_jwt_token(user)
        payload = { user_id: user.id }
        JWT.encode(payload, jwt_secret_key, 'HS256')
    end
end
