class Admin::TopController < ApplicationController
  #管理者アカウントのみがアクセスできる
  before_action :admin_user

  def index
  end
end
