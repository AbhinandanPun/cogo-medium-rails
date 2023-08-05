class SearchController < ApplicationController
    skip_before_action :authenticate_user, :verify_authenticity_token
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

    private
    def paginate_posts(posts, page_num)        
        per_page = 10
        total_pages = (posts.count.to_f / per_page).ceil
        posts = posts.paginate(page: page_num, per_page: per_page)
        posts = posts.map { |post| {
                                        id: post.id,
                                        title: post.title,
                                        topic: post.topic,
                                        created_at: post.created_at,
                                        author: {
                                            name: post.user.username,
                                            email: post.user.email
                                        },        
                                        file_url: (post&.image&.attached?) ? url_for(post.image) : nil
                                    }
                                }
        {total_pages: total_pages, per_page: per_page, current_page: (page_num || 1).to_i, posts: posts}
    end
end
