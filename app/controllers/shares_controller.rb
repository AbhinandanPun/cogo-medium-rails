class SharesController < ApplicationController
    before_action :authenticate_user
    def share_list
        begin
            list = List.find_by(id)
            if list
                ShareListAndPostMailer.share_list_email(list, @current_user, recipient_email).deliver_now
                # redirect_to list, notice: "List shared successfully"
                render json: {message: "list shared"}, status: :ok
            else
                render json: {message: 'list not found'}, status: :not_found
            end
        rescue => e
            render  json: { error: e.message }, status: :internal_server_error 
        end
    end
    def share_post
        begin
            post = Post.find_by(id)
            if post
                recipient_email = params[:recipient_email]
            
                ShareListAndPostMailer.share_post(post, @current_user, recipient_email).deliver_now
                render json: {message: "post shared"}, status: :ok
            else
                render json: {message: 'post not found'}, status: :not_found
            end
        rescue => e
            render  json: { error: e.message }, status: :internal_server_error 
        end
    end
    private
    def id
        params.permit(:id)
    end
    def recipient_email
        params.permit(:recipient_email)
    end
end
