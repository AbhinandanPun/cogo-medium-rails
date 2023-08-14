module FollowHelper
    def follow
        @follower = User.find_by(id: @current_user.id)
        Following.create(follower_id: @follower.id, followed_id: @following.id)
        increment_follower_count()
        increment_following_count() 
    end

    def unfollow
        @alreadyFollowed.destroy
        decrement_follower_count()
        decrement_following_count() 
    end

    def increment_follower_count()
        @current_user.follower_count = @current_user.follower_count + 1
        @current_user.save
    end

    def increment_following_count()
        @following.following_count = @following.following_count + 1
        @following.save
    end

    def decrement_follower_count()
        @current_user.follower_count = @current_user.follower_count - 1
        @current_user.save
    end
    
    def decrement_following_count()
        @following.following_count = @following.following_count - 1
        @following.save
    end
end
