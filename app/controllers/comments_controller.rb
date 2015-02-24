class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    # binding.pry
    # @post.comments.create(params[:comment])
  end
end
