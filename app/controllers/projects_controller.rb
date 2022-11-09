class ProjectsController < ApplicationController
  def index
  end
  def show
    @project = Project.kept.find_by(id: params[:id])
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
    @project = Project.kept.find_by(id: params[:id])
  end
  def update
    @project = Project.kept.find_by(id: params[:id])
    if @project.update(project_params)
      flash[:notice] = "変更を保存しました"
      redirect_to("/projects/#{@post.id}")
    else
      render("projects/edit")
    end
  end
  def destroy
  end

  private
  def project_params
    params.require(:project).permit(:name, :about)
  end
end
