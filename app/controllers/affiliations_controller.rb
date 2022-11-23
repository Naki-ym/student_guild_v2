class AffiliationsController < ApplicationController
  #ログインしていないユーザーがアクセスできない
  before_action :authenticate_user!
  #プロジェクトに所属していないとアクセスできない
  before_action :project_member

  def index
  end

  def new
    @users   = current_user.following_user - @project.users
  end

  def show
    @affiliation = Affiliation.find_by(id: params[:id])
  end

  def create
    user_ids = params[:users]
    if user_ids
      user_ids.each do |user_id|
        @affiliation = Affiliation.new(
          project_id: params[:project_id],
          user_id:    user_id,
          is_master: false
        )
        unless @affiliation.save
          @users = current_user.following_user - @project.users
          render("affiliations/new")
          exit
        end
      end
      flash[:notice] = "追加しました"
      redirect_to("/projects/#{params[:project_id]}")
    else
      @users = current_user.following_user - @project.users
      render("affiliations/new")
    end
  end

  def destroy
    Affiliation.find_by(id: params[:id]).destroy
    redirect_to("/projects/#{params[:project_id]}/affiliations")
  end

  def grant_master
    aff = Affiliation.find_by(id: params[:id])
    aff.update(is_master: true)
    redirect_to("/projects/#{params[:project_id]}/affiliations/#{params[:id]}")
  end
end
