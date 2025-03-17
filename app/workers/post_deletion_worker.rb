class PostDeletionWorker
  include Sidekiq::Worker

  def perform(post_id)
    post = Post.find_by(id: post_id)
    if post.nil?
      logger.info({ message: "Post not found for deletion", post_id: post_id }.to_json)
    else
      post.destroy
      logger.info({ message: "Post deleted successfully", post_id: post_id }.to_json)
    end
  rescue => e
    logger.error({ message: "Failed to delete post", post_id: post_id, error: e.message }.to_json)
    raise e # Re-raise the exception to mark the job as failed
  end
end