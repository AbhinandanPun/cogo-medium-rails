class CommentController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user 
    include CommentHelper
    def comment
        # begin
            @post = Post.find_by(id: params[:post_id].to_i)
            if @post
                @comment = Comment.find_by(user: @current_user, post: @post)
                if @comment
                    editComment()
                    render json: { message: "Comment Edited"}, status: :bad_request 
                else
                    comment = addComment()
                    render json: { message: "comment added successfully" }, status: :created
                end
            else
                render json: { errors: "Post Not Found" }, status: :not_found
            end
        # rescue => e
        #     render json: { error: e.message }, status: :internal_server_error
        # end
    end
end
