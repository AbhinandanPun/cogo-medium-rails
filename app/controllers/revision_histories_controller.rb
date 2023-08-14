class RevisionHistoriesController < ApplicationController
    before_action :authenticate_user
    def show
        revision_history = @current_user.revision_histories
        render json: revision_history, status: :ok
    end
    def undo_delete
        post_data = JSON.parse(@current_user.revision_histories.find_by(revision_id).post_data)
        post_data.slice!("title", "text", "topic")
        @post = Post.new(post_data)
        @post.update(user: @current_user)
        if @post
            render json: { post: @post, message:'created successfully'}, status: :created
        else
            render json: { message:'not created'}, status: :unprocessable_entity
        end
    end

    private
    def revision_id
        params.permit(:id)
    end
end
