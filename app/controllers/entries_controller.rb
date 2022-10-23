class EntriesController < ApplicationController
  #ログインしていないユーザーがアクセスできない
  before_action :authenticate_user!

  def index
    @entries = Entry.kept.where(project_id: params[:project_id])
  end

  def new
    @project = Project.kept.find_by(id: params[:project_id])
    @entry   = Entry.new
  end

  def create
    @entry = Entry.new(entry_params)
    #応募済みでないか
    unless Entry.kept.find_by(user_id: current_user.id, project_id: params[:project_id])
      if @entry.save
        redirect_to("/projects/#{params[:project_id]}")
      else
        render("entries/new")
      end
    else
      @project = Project.kept.find_by(id: params[:project_id])
      render("entries/new")
    end
  end

  private
  def entry_params
    params.require(:entry).permit(:content).merge(user_id: current_user.id, project_id: params[:project_id])
  end
end
