class DraftsController < ApplicationController
    before_action :authenticate_user
    #post drafts/
    def create
        begin
            draft_data = JSON.parse(draft_params['draft_data'])   
            image = draft_params['image']     
            @draft = Draft.new(draft_data)
            @draft.update(user: @current_user)
            if @draft.save
                if image.present? 
                    @draft.image.attach(image)
                end
                response = {
                    draft: @draft,        
                    file_url: (@draft&.image&.attached?) ? url_for(@draft.image) : nil
                }
                render json: response, status: :created   
            else
                render json: { errors: "something went wrong"}, status: :unprocessable_entity
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    #put drafts/
    def update
        draft_data = JSON.parse(draft_params['draft_data'])  
        begin
            @draft = Draft.find_by(draft_param_id, @current_user)
            if @draft and @draft.update(draft_data)
                @draft.save
                render json: { draft: @draft, message: ' edited successful' }, status: :ok 
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
            draft = Draft.find_by(draft_param_id)
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
            draft = Draft.find_by(draft_param_id, user: @current_user)
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
            @draft = Draft.find_by(draft_param_id, @current_user)
            if @draft
                if @draft.title.strip.empty? or @draft.text.strip.empty?  or @draft.topic.strip.empty?
                    render json: {errors: "No Field should be empty"}, status: :bad_request
                else
                    @post = @draft.convert_to_post # in model draft
                    @post.read_time = average_reading_time(@draft.text)
                    if @post.save and @draft.destroy
                        if (@draft&.image&.attached?)
                            @post.image.attach(@draft.image)
                        end
                        response = {
                            post: @post,        
                            file_url: (@post&.image&.attached?) ? url_for(@post.image) : nil
                        }
                        render json: @post, status: :created
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

    def draft_params
        params.permit(:draft_data, :image)
    end
    
    def draft_param_id
        params.permit(:id)
    end
    def average_reading_time(text)
        words_count = text.strip.split(" ").size
        minutes = words_count.to_f / 183
        return (minutes * 60).to_i + 20
    end
end
