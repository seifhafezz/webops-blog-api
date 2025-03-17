class CommentsController < ApplicationController
    before_action :authorize_request
    before_action :set_comment, only: [:update, :destroy]
    before_action :check_ownership, only: [:update, :destroy]
  
    def create
      @post = Post.find(params[:post_id])
      @comment = @post.comments.build(comment_params)
      @comment.user = current_user
  
      if @comment.save
        render json: @comment, status: :created
      else
        render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def update
      if @comment.update(comment_params)
        render json: @comment
      else
        render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def destroy
      @comment.destroy
      head :no_content
    end
  
    private
  
    def set_comment
      @comment = Comment.find(params[:id])
    end
  
    def check_ownership
      unless @comment.user == current_user
        render json: { error: "Unauthorized" }, status: :forbidden
      end
    end
  
    def comment_params
      params.require(:comment).permit(:body)
    end
  end