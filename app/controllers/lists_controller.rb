class ListsController < ApplicationController
    before_action :authenticate_user
    
    def create
        begin
            list = List.create(name: params[:list_name], user: @current_user)
            if list
                render json: {list_id: list.id, list_name: params[:list_name], message: "List creation successful"}, status: :created
            else
                render json: "Something went wrong", status: :bad_request
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    def destroy
        begin
            list = List.find_by(id: params[:id])
            list.destroy()
            if list
                render json: {message: "List deletion successful"}, status: :ok
            else
                render json: "Something went wrong", status: :bad_request
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    def add_to_list
        begin
            list = List.find_by(id: params[:list_id])
            listPost = ListPost.create(list: list, post_id: params[:post_id])
            if listPost
                render json: {message: "post addition to list successful"}, status: :created
            else
                render json: "Something went wrong", status: :bad_request
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    def remove_from_list
        begin
            list = List.find_by(id: params[:list_id])
            listPost = ListPost.find_by(list: list, post_id: params[:post_id])
            listPost.destroy()
            if listPost
                render json: {message: "post deletion from list successful"}, status: :created
            else
                render json: "Something went wrong", status: :bad_request
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
    def show
        begin
            list = List.find_by(id: params[:list_id])
            if list
                posts = ListPost.where(list: list).pluck(:post_id)
                render json: {list: list, post_ids: posts} , status: :created
            else
                render json: "Something went wrong", status: :bad_request
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
end
