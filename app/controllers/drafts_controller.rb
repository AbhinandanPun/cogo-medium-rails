class DraftsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_user
    #post drafts/
    def create
        begin
            draft_params = permit_draft_params
            draft_data = JSON.parse(draft_params['draft_data'])   
            image = draft_params['image']
            draft = Draft.new(title: draft_data['title'], 
                            text: draft_data['text'], 
                            topic: draft_data['topic'], 
                            user: @current_user
                        )
            if draft.save
                if image.present? 
                    draft.image.attach(image)
                end
                response = {
                    id: draft.id,
                    title: draft.title,
                    topic: draft.topic,
                    text: draft.text,
                    created_at: draft.created_at,
                    author: {
                        name: draft.user.username,
                        id: draft.user_id
                    },        
                    file_url: (draft&.image&.attached?) ? url_for(draft.image) : nil
                }
                render json: draft, status: :created   
            else
                render json: { errors: "something went wrong"}, status: :unprocessable_entity
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    #put drafts/
    def update
        begin
            draft = Draft.find_by(id: params[:id], user: @current_user)
            if draft
                if params[:title].strip != ""
                    draft.title = params[:title]
                end
                if params[:text].strip != ""
                    draft.text = params[:text]
                end
                if params[:topic].strip != "" 
                    draft.topic = params[:topic]
                end
                draft.save
                render json: { draft: draft, message: ' edited successful' }, status: :ok 
            else
                render json: { error: 'draft not found' }, status: :not_found
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    #get drafts/
    def show
        begin
            draft = Draft.find_by(id: params[:id])
            if draft
                response_data = {
                    draft: draft,
                    file_url: (draft&.image&.attached?) ? url_for(draft.image) : nil
                }
                render json: response_data, status: :ok  
            else
                render json: { errors: "Draft Not Found" }, status: :not_found
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    def destroy
        begin
            draft_id = params[:id].to_i
            draft = Draft.find_by(id: draft_id, user: @current_user)
            if draft
                draft.destroy
                render json: { message: ' Deletion successful' }, status: :ok         
            else 
                render json: { error: 'Draft not found' }, status: :not_found
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    #post drafts/
    def post
        begin
            draft_id = params[:id].to_i
            draft = Draft.find_by(id: draft_id, user: @current_user)
            if draft
                draft_params = permit_draft_params
                draft_data = JSON.parse(draft_params['draft_data'])   
                image = draft_params['image']
                if draft_data['title'].strip.empty? or draft_data['text'].strip.empty?  or draft_data['topic'].strip.empty?
                    render json: {errors: "No Field should be empty"}, status: :bad_request
                else
                    post = Post.new(title: draft_data['title'], 
                                text: draft_data['text'], 
                                topic: draft_data['topic'], 
                                user: @current_user, 
                                read_time: average_reading_time(draft_data['text']) #in seconds
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
                        draft.destroy
                        render json: response, status: :created
                    else
                        render json: { errors: "something went wrong"}, status: :unprocessable_entity
                    end
                end
            else 
                render json: { error: 'Draft not found' }, status: :not_found
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end

    private

    def average_reading_time(text)
        words_count = text.strip.split(" ").size
        # average reading time is 183 words per minute
        # acc. to IEEE research
        minutes = words_count.to_f / 183
        # +20 to read the topic or title or seeing hero image
        return (minutes * 60).to_i + 20
    end
    def permit_draft_params
        params.permit(:draft_data, :image)
    end
end
