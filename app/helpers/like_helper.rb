module LikeHelper
    def unlikePost()
        @like.destroy
        DecrementLikeCount()
        deleteInteractionHistory()
    end
    def likePost()
        Like.create(user: @current_user, post: @post)
        IncrementLikeCount()
        addInteractionHistory()
    end
    def IncrementLikeCount()
        @post.like_count = @post.like_count + 1
        @post.save
    end
    def DecrementLikeCount()
        @post.like_count = @post.like_count - 1
        @post.save
    end
    def addInteractionHistory()
        if !(@current_user.interaction_histories.exists?(post_id: @post.id))
            @current_user.interaction_histories.create(post: @post, interaction_type: "like")
        end
    end 
    def deleteInteractionHistory()
        interaction_history = @current_user.interaction_histories.find_by(post: @post)
        interaction_history.destroy
    end
end
