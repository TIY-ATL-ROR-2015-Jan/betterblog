class UsersController < ApplicationController
  def index
    @users = User.all
    render :index
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: "User deleted."
  end
end
