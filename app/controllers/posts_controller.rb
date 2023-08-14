class PostsController < ApplicationController
    before_action :authenticate_user, except: [:index, :filter, :topic]
    include PostsHelper

    
    def create
        begin
            post_data = JSON.parse(post_params['post_data'])   
            image = post_params['image']

            @post = @current_user.posts.new(post_data)
            @post.read_time = average_reading_time(post_data)

            if @post.save
                if image.present? 
                    @post.image.attach(image)
                end
                response = {
                    post: @post,        
                    file_url: (@post&.image&.attached?) ? url_for(@post.image) : nil
                }

                revision_history_service('create')
                render json: response, status: :created
            else
                render json: { errors: 'something went wrong'}, status: :unprocessable_entity
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    def destroy
        begin
            @post = Post.find_by(post_param_id, @current_user)
            if @post
                @post.destroy
                revision_history_service('delete')
                render json: { message: 'Deletion successful' }, status: :ok         
            else 
                render json: {post: post_param_id,  message: 'Post Not Found'}, status: :not_found
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    def update
        begin
            post_data = JSON.parse(post_params['post_data'])  
            @post = Post.find_by(post_param_id, @current_user)
            if @post and @post.update(post_data)
                @post.save
                revision_history_service('update')
                render json: { message: ' edit successful ' }, status: :created 
            else
                render json: { error: 'post not found' }, status: :not_found
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    def index
        begin
            posts = Post.all
            render json: paginate_posts(posts, params[:page]), status: :ok
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    
    def show
        begin
            @post = Post.find_by(post_param_id)
            if @post 
                if check_daily_view_limit
                    @view = View.find_by(user: @current_user, post: @post)
                    if @view.nil? 
                        @view = view()
                    end
                    response_data = {
                        post: @post,
                        file_url: (@post&.image&.attached?) ? url_for(@post.image) : nil,
                        comments: @post.comments,
                        more_posts_by_user: more_posts_by_user
                    }
                    render json: response_data, status: :ok  
                else
                    render json: { message:"views exhausted" }
                end
            else
                render json: { errors: "Post Not Found" }, status: :not_found
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    def filter
        begin
            posts = Post.where('like_count >= ? and comment_count >= ?', params[:min_likes].to_i,  params[:min_comments].to_i)
            posts = posts.where(created_at: params[:start_date]..params[:end_date])
            if posts
                render json: paginate_posts(posts, params[:page]), status: :ok
            else
                render json: {message: "no data"}
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    def topic
        begin
            posts = Post.where('topic LIKE ?', "%#{params[:name].upcase}%")
            if !posts.empty?
                render json: paginate_posts(posts, params[:page]), status: :ok
            else
                render json: {errors: "no posts found"}, status: :not_found
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    def recommend
        begin
            posts = recommended_posts
            if !posts.empty?
                render json: paginate_posts(posts, params[:page]), status: :ok
            else
                render json: {errors: "no posts found"}, status: :not_found
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end

    private
    
    def post_params
        params.permit(:post_data, :image)
    end
    def post_param_id
        params.permit(:id)
    end
    def more_posts_by_user
        @post.user.posts.where.not(id: @post.id).limit(5)
    end
    def check_daily_view_limit
        daily_view_limit = get_daily_view_limit()
        todays_view_count  =   View.where(user: @current_user)
                        .where('created_at >= ?', 24.hours.ago)
                        .count
        # puts daily_view_limit
        # puts @subscriptions.nil?
        # puts todays_view_count
        todays_view_count < daily_view_limit
    end
    def get_daily_view_limit
        @subscriptions = Subscription.find_by(user: @current_user)
        if @subscriptions.nil?
            daily_view_limit = 1
        else
            daily_view_limit = SubscriptionPlan.find_by(id: @subscriptions.subscription_plan_id)&.daily_view_limit
        end
    end
end


