class SearchController < ApplicationController
    skip_before_action :authenticate_user
    include SearchHelper
    def search_users
        begin
            query = params[:query]
            if query.strip.empty?
                render json: {errors: "no search query"}, status: :bad_request
            else
                users = User.where('username LIKE ?', "%#{query}%")
                if !users.empty?
                    users = users.map { |user| {
                        id: user.id,
                        username: user.username,
                        email: user.email,
                        follower_count: user.follower_count,
                        following_count: user.following_count
                    }}
                    render json: users, status: :ok
                else
                    render json: {errors: "no user found"}, status: :not_found
                end
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    def search_posts
        begin
            query = params[:query]
            if query.strip.empty?
                render json: {errors: "no search query"}, status: :bad_request
            else
                posts = Post.joins(:user).where('posts.topic LIKE ? OR posts.title LIKE ? OR users.username LIKE ?', "%#{query}%", "%#{query}%", "%#{query}%")
                render json: { users: users, posts: posts, topics: topics }
                if !posts.empty?
                    render json: paginate_posts(posts, params[:page]), status: :ok
                else
                    render json: {errors: "no posts found"}, status: :not_found
                end
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
end
