class UsersController < ApplicationController
  def show
  end

  def settings
  end

  def follows
    @user   = User.kept.find_by(id: params[:id])
    @following_users = @user.following_user
    @follower_users  = @user.follower_user
    @users = @user.following_user.reverse_order
  end

  def followers
    @user   = User.kept.find_by(id: params[:id])
    @following_users = @user.following_user
    @follower_users  = @user.follower_user
    @users = @user.follower_user.reverse_order
  end

  def admin_settings
  end
end
