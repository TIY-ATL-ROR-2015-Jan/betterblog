class CommentsController < ApplicationController
  before_action :set_user

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(:body => params[:comment][:body])
    respond_to do |format|
      format.html { redirect_to [@user, @post] }
      format.js { render :create }
    end
  end

  private
  def set_user
    @user = User.find(params[:user_id])
  end
end
