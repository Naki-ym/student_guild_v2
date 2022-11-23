class ProjectsController < ApplicationController
  #ログインしていないユーザーがアクセスできない
  before_action :authenticate_user!
  #プロジェクトに所属していないとアクセスできない
  before_action :project_member, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      @affiliation = Affiliation.new(user_id: current_user.id, project_id: @project.id, is_master: true)
      if @affiliation.save
        flash[:notice] = "作成しました"
        redirect_to("/projects")
      else
        render("projects/new")
      end
    else
      render("projects/new")
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      flash[:notice] = "変更を保存しました"
      redirect_to("/projects/#{@project.id}")
    else
      render("projects/edit")
    end
  end

  def destroy
    @project.discard
    redirect_to("/projects")
  end

  private
  def project_params
    params.require(:project).permit(:name, :about)
  end
end
