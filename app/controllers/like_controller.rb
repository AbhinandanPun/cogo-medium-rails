class LikeController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user 
    include LikeHelper
    def like
        begin
            @post = Post.find_by(id: params[:post_id].to_i)
            if @post
                @like = Like.find_by(user: @current_user, post: @post)
                if @like
                    unlikePost()
                    render json: { message: "Post unliked successfully" }, status: :ok
                else
                    like = likePost()
                    render json: { message: "Post liked successfully" }, status: :created
                end
            else
                render json: { errors: "Post Not Found" }, status: :not_found
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
end
