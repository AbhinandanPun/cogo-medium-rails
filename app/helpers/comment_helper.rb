module CommentHelper
    def add_interaction_history()
        if !(@current_user.interaction_histories.exists?(post_id: @post.id))
            @current_user.interaction_histories.create(post: @post, interaction_type: "comment")
        end
    end
    def increment_comment_count()
        @post.comment_count = @post.comment_count + 1
        @post.save
    end
    def add_comment() 
        Comment.create(content: params[:content], user: @current_user, post: @post)
        increment_comment_count()
        add_interaction_history()
    end
    def edit_comment()
        @comment.content = params[:content]
    end
end
