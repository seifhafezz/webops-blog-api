class PostsController < ApplicationController  
    before_action :authorize_request, except: [:index, :show]  
    before_action :set_post, only: [:show, :update, :destroy]  
  
    def index  
      @posts = Post.all  
      render json: @posts  
    end  
  
    def show  
      render json: @post  
    end  
  
    def create  
      @post = current_user.posts.build(post_params)  
      if @post.save  
        PostDeletionWorker.perform_in(24.hours, @post.id) # Schedule deletion  
        
        logger.info "Scheduled deletion for post ID: #{@post.id}" # Debug log
        render json: @post, status: :created  
      else  
        render json: { error: @post.errors.full_messages }, status: :unprocessable_entity  
      end  
    end  
  
    def update  
      if @post.author == current_user && @post.update(post_params)  
        render json: @post  
      else  
        render json: { error: "Unauthorized or invalid input" }, status: :forbidden  
      end  
    end  
  
    def destroy  
      if @post.author == current_user  
        @post.destroy  
        head :no_content  
      else  
        render json: { error: "Unauthorized" }, status: :forbidden  
      end  
    end  
  
    private  
  
    def set_post  
      @post = Post.find(params[:id])  
    end  
  
    def post_params  
        puts params.inspect
        params.require(:post).permit(:title, :body, :tags)  
    end  
  end  