class UsersController < ApplicationController
  def show
    @user  = User.find_by(id: params[:id])
    @posts = Post.kept.where(user_id: @user.id).order(created_at: :desc)
  end

  def settings
  end

  def follows
    @user   = User.find_by(id: params[:id])
    @users = @user.following_user.reverse_order
  end

  def followers
    @user   = User.find_by(id: params[:id])
    @users = @user.follower_user.reverse_order
  end
end
