module ApplicationHelper
    def jwt_secret_key
        Rails.application.secrets.jwt_secret_key
    end
end
