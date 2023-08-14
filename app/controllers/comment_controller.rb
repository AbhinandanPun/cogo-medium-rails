class CommentController < ApplicationController
    before_action :authenticate_user 
    include CommentHelper
    def comment
        begin
            @post = Post.find_by(comment_id)
            if @post
                @comment = Comment.find_by(user: @current_user, post: @post)
                if @comment
                    edit_comment()
                    render json: { message: "Comment Edited"}, status: :ok 
                else
                    comment = add_comment()
                    render json: { message: "comment added successfully" }, status: :created
                end
            else
                render json: { errors: "Post Not Found" }, status: :not_found
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end

    private
    def comment_id
        post_id = params.permit(:id)
    end
end
