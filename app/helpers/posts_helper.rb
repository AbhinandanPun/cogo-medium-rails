module PostsHelper

    def revision_history_service(action)
        RevisionHistory.create(user: @current_user, action: action, post_data: @post.to_json)
    end

    def paginate_posts(posts, page_num)                
        per_page = 10
        sorted_posts = posts.sort_by { |post| -engagement_rate_for_top_post(post) }

        total_posts = sorted_posts.count
        total_pages = (total_posts.to_f / per_page).ceil
      
        current_page = [page_num.to_i, 1].max
        offset = (current_page - 1) * per_page
        paginated_posts = sorted_posts[offset, per_page]
        
        paginated_posts = paginated_posts.map { |post| {
                post: post,
                author: {
                    id: post.user.id,
                    name: post.user.username,
                    email: post.user.email
                },        
                file_url: (post&.image&.attached?) ? url_for(post.image) : nil
            }
        }
        { total_pages: total_pages, per_page: per_page, current_page: current_page, posts: paginated_posts }
    end
    
    def average_reading_time(post)
        text = post['text']
        words_count = text.strip.split(" ").size
        minutes = words_count.to_f / 183
        # +20 to read the topic or title or seeing hero image
        return (minutes * 60).to_i + 20
    end

    def view
        View.create(user: @current_user, post: @post)
        increment_view_count
        add_interaction_history
    end

    def increment_view_count
        @post.view_count = @post.view_count + 1
        @post.save
    end

    def add_interaction_history
        @current_user.interaction_histories.create(post: @post, interaction_type: "view")
    end 

    def recommended_posts
        user_interactions = @current_user.interaction_histories.where(interaction_type: ["like", "view", "comment"])
        liked_posts = user_interactions.where(interaction_type: "like").pluck(:post_id)
        viewed_posts = user_interactions.where(interaction_type: "view").pluck(:post_id)
        commented_posts = user_interactions.where(interaction_type: "comment").pluck(:post_id)

        user_ids_with_likes = InteractionHistory.where(post_id: liked_posts, interaction_type: "like").pluck(:user_id).uniq - [@current_user.id]
        user_ids_with_views = InteractionHistory.where(post_id: viewed_posts, interaction_type: "view").pluck(:user_id).uniq - [@current_user.id]
        user_ids_with_comments = InteractionHistory.where(post_id: commented_posts, interaction_type: "comment").pluck(:user_id).uniq - [@current_user.id]

        unique_user_ids = (user_ids_with_likes + user_ids_with_views + user_ids_with_comments).uniq
        recommended_posts = InteractionHistory.where(user_id: unique_user_ids, interaction_type: ["like", "view", "comment"]).pluck(:post_id).uniq
        posts = Post.where(id: recommended_posts)
    end

    def engagement_rate_for_top_post(post)
        max_likes = Post.maximum(:like_count)
        max_views = Post.maximum(:view_count)
        max_comments = Post.maximum(:comment_count)
        max_time_difference = Time.now - Post.minimum(:created_at)
    
    
        normalized_likes = (post.like_count.to_f / max_likes).nan? ? 0 : (post.like_count.to_f / max_likes)
        normalized_views = (post.view_count.to_f / max_views).nan? ? 0 : (post.view_count.to_f / max_views)
        normalized_comments = (post.comment_count.to_f / max_comments).nan? ? 0 : (post.comment_count.to_f / max_comments)
        time_factor = 1 - (Time.now - post.created_at) / max_time_difference
        
        weight_likes = 3
        weight_views = 2
        weight_comments = 1
        weight_time = 1  
    
        weighted_engagement_rate = (normalized_likes * weight_likes) +
                                  (normalized_views * weight_views) +
                                  (normalized_comments * weight_comments) +
                                  (time_factor * weight_time)
                                  
                                  puts "weighted_engagement_rate: #{weighted_engagement_rate}"
        weighted_engagement_rate
      end
end
