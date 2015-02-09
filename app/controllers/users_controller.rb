class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    redirect_to :action => :index
  end

  def index
    @users = User.all
    render :index
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: "User deleted."
  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
