module FollowHelper
    def follow
        @follower = User.find_by(id: @current_user.id)
        Following.create(follower_id: @follower.id, followed_id: @following.id)
        incrementFollowerCount()
        incrementFollowingCount() 
    end

    def unfollow
        @alreadyFollowed.destroy
        decrementFollowerCount()
        decrementFollowingCount() 
    end

    def incrementFollowerCount()
        @current_user.follower_count = @current_user.follower_count + 1
        @current_user.save
    end

    def incrementFollowingCount()
        @following.following_count = @following.following_count + 1
        @following.save
    end

    def decrementFollowerCount()
        @current_user.follower_count = @current_user.follower_count - 1
        @current_user.save
    end
    
    def decrementFollowingCount()
        @following.following_count = @following.following_count - 1
        @following.save
    end
end
