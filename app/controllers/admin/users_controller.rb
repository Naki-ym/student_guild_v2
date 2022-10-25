class Admin::UsersController < ApplicationController
  #管理者アカウントのみがアクセスできる
  before_action :admin_user

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def grant_admin
    @user = User.find_by(id: params[:id])
    @user.update(admin: true)
    redirect_to("/admin/users")
  end
end
