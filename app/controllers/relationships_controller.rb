class RelationshipsController < ApplicationController
  #ログインしていないユーザーがアクセスできない
  before_action :authenticate_user!

  def create
    @user = User.find_by(id: params[:user_id])
    current_user.follow(params[:user_id])
  end
  
  def destroy
    @user = User.find_by(id: params[:user_id])
    current_user.unfollow(params[:user_id])
  end
end
