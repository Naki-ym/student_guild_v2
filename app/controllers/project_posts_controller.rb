class ProjectPostsController < ApplicationController
  #ログインしていないユーザーがアクセスできない
  before_action :authenticate_user!
  #プロジェクトに所属していないとアクセスできない
  before_action :project_member

  def index
    @pj_posts = ProjectPost.kept.order(created_at: :desc)
  end

  def new
    @pj_post = ProjectPost.new
  end

  def create
    @pj_post = ProjectPost.new(pj_post_params)
    if @pj_post.save
      flash[:notice] = "投稿しました"
      redirect_to("/projects/#{params[:project_id]}/project_posts")
    else
      @pj_posts = ProjectPost.kept.where(user_id: @followings_id).order(created_at: :desc)
      render("project_posts/new")
    end
  end

  def edit
    @pj_post = ProjectPost.kept.find_by(id: params[:id])
  end

  def update
    @pj_post = ProjectPost.kept.find_by(id: params[:id])
    if @pj_post.update(pj_post_params)
      flash[:notice] = "変更を保存しました"
      redirect_to("/projects/#{params[:project_id]}/project_posts/")  
    else
      @content = @pj_post.content
      render("project_posts/edit")
    end
  end

  def destroy
    @pj_post = ProjectPost.kept.find_by(id: params[:id])
    @pj_post.discard
    flash[:notice] = "投稿を削除しました"
    redirect_to("/projects/#{params[:project_id]}/project_posts")
  end

  private
  def pj_post_params
    params.require(:project_post).permit(:content).merge(project_id: params[:project_id], user_id: current_user.id)
  end
end
