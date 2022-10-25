class UsersController < ApplicationController
  def show
    @user            = User.find_by(id: params[:id])
    @posts           = Post.kept.where(user_id: @user.id).order(created_at: :desc)
    @following_users = @user.following_user
    @follower_users  = @user.follower_user
  end

  def settings
  end

  def follows
    @user   = User.find_by(id: params[:id])
    @following_users = @user.following_user
    @follower_users  = @user.follower_user
    @users = @user.following_user.reverse_order
  end

  def followers
    @user   = User.find_by(id: params[:id])
    @following_users = @user.following_user
    @follower_users  = @user.follower_user
    @users = @user.follower_user.reverse_order
  end
end
