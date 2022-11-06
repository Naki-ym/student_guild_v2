class EntriesController < ApplicationController
  #ログインしていないユーザーがアクセスできない
  before_action :authenticate_user!

  def index
    @entries = Entry.kept.where(recruitment_id: params[:recruitment_id])
  end

  def new
    @recruitment = Recruitment.kept.find_by(id: params[:recruitment_id])
    @entry   = Entry.new
  end

  def create
    @entry = Entry.new(entry_params)
    #応募済みでないか
    unless Entry.kept.find_by(user_id: current_user.id, recruitment_id: params[:recruitment_id])
      if @entry.save
        redirect_to("/recruitments/#{params[:recruitment_id]}")
      else
        render("entries/new")
      end
    else
      @recruitment = Recruitment.kept.find_by(id: params[:recruitment_id])
      render("entries/new")
    end
  end

  private
  def entry_params
    params.require(:entry).permit(:content).merge(user_id: current_user.id, recruitment_id: params[:recruitment_id])
  end
end
