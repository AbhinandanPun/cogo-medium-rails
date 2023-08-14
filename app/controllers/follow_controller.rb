class FollowController < ApplicationController
    before_action :authenticate_user 
    include FollowHelper
    def follow_user
        begin
            @following = User.find_by(username)
            if @following == nil
                render json: {errors: "User not found"}, status: :not_found
                return
            elsif @current_user.username == params[:username]
                render json: {errors: "Cannot follow Oneself"}, status: :bad_request
                return
            end

            @alreadyFollowed = Following.find_by(follower_id: @current_user.id, followed_id: @following.id)
            if  @alreadyFollowed
                unfollow() 
                render json: {message: "UnFollowed user", unfollowed: params[:username]}, status: :ok
            else
                follow()
                render json: {message: "Now Following user", unfollowed: params[:username]}, status: :ok
            end 
        rescue => e
            render json: { error: e.message }, status: :internal_server_error 
        end
    end
    private
    def username
        params.permit(:username)
    end
end
