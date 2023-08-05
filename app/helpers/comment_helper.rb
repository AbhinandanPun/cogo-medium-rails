module CommentHelper
    def addInteractionHistory()
        if !(@current_user.interaction_histories.exists?(post_id: @post.id))
            @current_user.interaction_histories.create(post: @post, interaction_type: "comment")
        end
    end
    def IncrementCommentCount()
        @post.comment_count = @post.comment_count + 1
        @post.save
    end
    def addComment() 
        Comment.create(content: params[:content], user: @current_user, post: @post)
        IncrementCommentCount()
        addInteractionHistory()
    end
    def editComment()
        @comment.content = params[:content]
    end
end
