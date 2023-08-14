module LikeHelper
    def unlike_post()
        @like.destroy
        decrement_like_count()
        delete_interaction_history()
    end
    def like_post()
        Like.create(user: @current_user, post: @post)
        increment_like_count()
        add_interaction_history()
    end
    def increment_like_count()
        @post.like_count = @post.like_count + 1
        if @post.like.count%100 == 0
            user_share()
        end
        @post.save
    end
    def decrement_like_count()
        @post.like_count = @post.like_count - 1
        @post.save
    end
    def add_interaction_history()
        if !(@current_user.interaction_histories.exists?(post_id: @post.id))
            @current_user.interaction_histories.create(post: @post, interaction_type: "like")
        end
    end 
    def delete_interaction_history()
        interaction_history = @current_user.interaction_histories.find_by(post: @post)
        interaction_history.destroy
    end
    def user_share()
        total_amount = 10666240.0
        subscribed_users = 40000
        likes_count = @post.like_count
        amount = 0.0
        bonus = 0.0  
        if likes_count >= 100
            amount = (likes_count / 100) * 100.0
            bonus = (likes_count / 100).floor * 500.0
        end
            # puts { post_id: @post.id, amount: amount + bonus }
    end
end
