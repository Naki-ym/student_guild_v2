class ProjectPostsController < ApplicationController
  #ログインしていないユーザーがアクセスできない
  before_action :authenticate_user!
  #プロジェクトに所属していないとアクセスできない
  before_action :project_member

  def index
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
