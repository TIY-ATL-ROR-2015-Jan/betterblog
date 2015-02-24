class CommentsController < ApplicationController
  before_action :set_user

  def create
    @post = Post.find(params[:post_id])
    @post.comments.create(:body => params[:comment][:body])
    redirect_to [@user, @post]
  end

  private
  def set_user
    @user = User.find(params[:user_id])
  end
end
