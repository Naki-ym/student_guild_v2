class ProjectsController < ApplicationController
  #ログインしていないユーザーがアクセスできない
  before_action :authenticate_user!

  def index
    @categories = TagCategory.kept.order(created_at: :asc)
    if params[:tag]
      @tag = Tag.kept.find_by(id: params[:tag].to_i)
      @projects = @tag.projects(current_user.id)
    else
      @projects = Project.kept.where.not(user_id: current_user.id).where(is_published: true).order(created_at: :desc)
    end
  end

  def myprojects
    @projects = Project.kept.where(user_id: current_user.id).order(created_at: :desc)
    if params[:is_published] == "true"
      @projects = @projects.where(is_published: true)
    elsif params[:is_published] == "false"
      @projects = @projects.where(is_published: false)
    end
  end

  def new
    @categories = TagCategory.kept.order(created_at: :asc)
    @project    = Project.new
    @tags       = Tag.kept.all.order(created_at: :asc)
  end

  def dynamic_tag
    if params[:project][:tag_category_id] != ""
      @category = TagCategory.find_by(id: params[:project][:tag_category_id])
      @tags = @category.tags
    else
      @tags = []
    end
  end

  def create
    @project = Project.new(
      user_id:     project_params["user_id"],
      name:        project_params["name"],
      overview:    project_params["overview"],
      target:      project_params["target"],
      detail:      project_params["detail"],
      tag_id:      params[:tag],
      image:       project_params["image"],
      image_cache: project_params["image_cache"]
    )
    if params[:tag] != "---" and @project.save
      redirect_to("/projects/myprojects")
    else
      @categories = TagCategory.kept.order(created_at: :asc)
      @tags = Tag.all.order(created_at: :asc)
      render("projects/new")
    end
  end

  def show
    @project = Project.kept.find_by(id: params[:id])
    @entry   = Entry.kept.find_by(user_id: current_user.id, project_id: params[:id])
  end

  def edit
    @categories = TagCategory.kept.order(created_at: :asc)
    @project    = Project.kept.find_by(id: params[:id])
    @tags       = Tag.kept.all.order(created_at: :asc)
    @tag        = @project.tag
  end

  def update
    @project = Project.kept.find_by(id: params[:id])
    @project.name        = project_params["name"]
    @project.overview    = project_params["overview"]
    @project.target      = project_params["target"]
    @project.detail      = project_params["detail"]
    @project.tag_id      = params[:tag]
    @project.image       = project_params["image"]
    @project.image_cache = project_params["image_cache"]
    if params[:tag] != "---" and @project.save
      flash[:notice] = "変更を保存しました"
      redirect_to("/projects/#{@project.id}/")
    else
      @categories = TagCategory.kept.order(created_at: :asc)
      @tags       = Tag.kept.all.order(created_at: :asc)
      @tag        = @project.tags.first
      render("projects/edit")
    end
  end

  def publish
    @project              = Project.kept.find_by(id: params[:id])
    @project.is_published = true
    @project.save
    redirect_to("/projects/myprojects")
  end

  def unpublish
    @project              = Project.kept.find_by(id: params[:id])
    @project.is_published = false
    @project.save
    redirect_to("/projects/myprojects")
  end

  def destroy
    #このプロジェクトへの応募も削除
    @project = Project.find_by(id: params[:id])
    @project.discard
    redirect_to("/projects/myprojects")
  end

  private
  def project_params
    params.require(:project).permit(:name, :overview, :target, :detail, :image, :image_cache, :tag, :tag_category_id).merge(user_id: current_user.id)
  end
end