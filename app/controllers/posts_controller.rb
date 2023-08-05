class PostsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user, except: [:index, :filter, :topic]
    include PostsHelper
    def create
        begin
            post_params = permit_post_params
            post_data = JSON.parse(post_params['post_data'])   
            image = post_params['image']
            if post_data['title'].strip.empty? or post_data['text'].strip.empty?  or post_data['topic'].strip.empty?
                render json: {errors: "No Field should be empty"}, status: :bad_request
            else
                post = Post.new(title: post_data['title'], 
                            text: post_data['text'], 
                            topic: post_data['topic'], 
                            user: @current_user, 
                            read_time: average_reading_time(post_data['text']) #in seconds
                        )
                if post.save
                    if image.present? 
                        post.image.attach(image)
                    end
                    response = {
                        id: post.id,
                        title: post.title,
                        topic: post.topic,
                        text: post.text,
                        created_at: post.created_at,
                        author: {
                            name: post.user.username,
                            id: post.user.id
                        },        
                        file_url: (post&.image&.attached?) ? url_for(post.image) : nil
                    }
                    render json: response, status: :created
                else
                    render json: { errors: "something went wrong"}, status: :unprocessable_entity
                end
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    def destroy
        begin
            post_id = params[:post_id].to_i
            post = Post.find_by(id: post_id, user: @current_user)
            if post
                post.destroy
                render json: { message: ' Deletion successful' }, status: :ok         
            else 
                render json: { message: 'Not Found'}, status: :not_found
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    def update
        begin
            post = Post.find_by(id: params[:post_id], user: @current_user)
            if post
                if params[:title].strip != "" 
                    post.title = params[:title]
                end
                if params[:text].strip != ""  
                    post.text = params[:text]
                    post.read_time = average_reading_time(params[:text])
                end
                if params[:topic].strip != "" 
                    post.topic = params[:topic]
                end
                post.save
                render json: { id: params[:post_id], message: ' edited successful' }, status: :ok 
            else
                render json: { error: 'post not found' }, status: :not_found
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    def index
        # begin
            posts = Post.all
            render json: paginate_posts(posts, params[:page]), status: :ok
        # rescue => e
        #     render json: { error: e.message }, status: :internal_server_error
        # end
    end
    def show
        begin
            @post = Post.find_by(id: params[:post_id])
            if @post
                @view = View.find_by(user: @current_user, post: @post)
                if @view.nil?
                    @view = view()
                end
                more_posts_by_user = Post.where(user: @post.user).where.not(id: @post.id).limit(5)
                response_data = {
                    post: @post,
                    file_url: (@post&.image&.attached?) ? url_for(@post.image) : nil,
                    comments: @post.comments,
                    more_posts_by_user: more_posts_by_user
                }
                render json: response_data, status: :ok  
            else
                render json: { errors: "Post Not Found" }, status: :not_found
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    def filter
        begin
            @posts = Post.where('like_count >= ? and comment_count >= ?', params[:min_likes].to_i,  params[:min_comments].to_i)
            @posts = @posts.where(created_at: params[:start_date]..params[:end_date])
            if @posts
                render json: paginate_posts(@posts, params[:page]), status: :ok
            else
                render json: {message: "no data"}
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    def topic
        begin
            posts = Post.where('topic LIKE ?', "%#{params[:topic].upcase}%")
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
            posts = recommendedPosts()
            if !posts.empty?
                render json: paginate_posts(posts, params[:page]), status: :ok
            else
                render json: {errors: "no posts found"}, status: :not_found
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
end


