module SearchHelper
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
