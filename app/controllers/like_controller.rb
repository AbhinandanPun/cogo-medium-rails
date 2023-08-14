class LikeController < ApplicationController
    before_action :authenticate_user 
    include LikeHelper
    def like
        begin
            @post = Post.find_by(id)
            if @post
                @like = Like.find_by(user: @current_user, post: @post)
                if @like
                    unlike_post()
                    render json: { post:@post, message: "Post unliked successfully" }, status: :ok
                else
                    like = like_post()
                    render json: { message: "Post liked successfully" }, status: :created
                end
            else
                render json: { errors: "Post Not Found" }, status: :not_found
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    
    private
    def id
        params.permit(:id)
    end
end
