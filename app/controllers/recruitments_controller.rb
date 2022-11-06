class RecruitmentsController < ApplicationController
  #ログインしていないユーザーがアクセスできない
  before_action :authenticate_user!

  def index
    @categories = TagCategory.kept.order(created_at: :asc)
    if params[:tag]
      @tag = Tag.kept.find_by(id: params[:tag].to_i)
      @recruitments = @tag.recruitments(current_user.id)
    else
      @recruitments = Recruitment.kept.where.not(user_id: current_user.id).where(is_published: true).order(created_at: :desc)
    end
  end

  def myrecruitments
    @recruitments = Recruitment.kept.where(user_id: current_user.id).order(created_at: :desc)
    if params[:is_published] == "true"
      @recruitments = @recruitments.where(is_published: true)
    elsif params[:is_published] == "false"
      @recruitments = @recruitments.where(is_published: false)
    end
  end

  def new
    @categories = TagCategory.kept.order(created_at: :asc)
    @recruitment    = Recruitment.new
    @tags       = Tag.kept.all.order(created_at: :asc)
  end

  def dynamic_tag
    if params[:recruitment][:tag_category_id] != ""
      @category = TagCategory.find_by(id: params[:recruitment][:tag_category_id])
      @tags = @category.tags
    else
      @tags = []
    end
  end

  def create
    @recruitment = Recruitment.new(
      user_id:     recruitment_params["user_id"],
      name:        recruitment_params["name"],
      overview:    recruitment_params["overview"],
      target:      recruitment_params["target"],
      detail:      recruitment_params["detail"],
      tag_id:      params[:tag],
      image:       recruitment_params["image"],
      image_cache: recruitment_params["image_cache"]
    )
    if params[:tag] != "---" and @recruitment.save
      redirect_to("/recruitments/myrecruitments")
    else
      @categories = TagCategory.kept.order(created_at: :asc)
      @tags = Tag.all.order(created_at: :asc)
      render("recruitments/new")
    end
  end

  def show
    @recruitment = Recruitment.kept.find_by(id: params[:id])
    @entry   = Entry.kept.find_by(user_id: current_user.id, recruitment_id: params[:id])
  end

  def edit
    @categories = TagCategory.kept.order(created_at: :asc)
    @recruitment    = Recruitment.kept.find_by(id: params[:id])
    @tags       = Tag.kept.all.order(created_at: :asc)
    @tag        = @recruitment.tag
  end

  def update
    @recruitment = Recruitment.kept.find_by(id: params[:id])
    @recruitment.name        = recruitment_params["name"]
    @recruitment.overview    = recruitment_params["overview"]
    @recruitment.target      = recruitment_params["target"]
    @recruitment.detail      = recruitment_params["detail"]
    @recruitment.tag_id      = params[:tag]
    @recruitment.image       = recruitment_params["image"]
    @recruitment.image_cache = recruitment_params["image_cache"]
    if params[:tag] != "---" and @recruitment.save
      flash[:notice] = "変更を保存しました"
      redirect_to("/recruitments/#{@recruitment.id}/")
    else
      @categories = TagCategory.kept.order(created_at: :asc)
      @tags       = Tag.kept.all.order(created_at: :asc)
      @tag        = @recruitment.tags.first
      render("recruitments/edit")
    end
  end

  def publish
    @recruitment              = Recruitment.kept.find_by(id: params[:id])
    @recruitment.is_published = true
    @recruitment.save
    redirect_to("/recruitments/myrecruitments")
  end

  def unpublish
    @recruitment              = Recruitment.kept.find_by(id: params[:id])
    @recruitment.is_published = false
    @recruitment.save
    redirect_to("/recruitments/myrecruitments")
  end

  def destroy
    #この募集への応募も削除
    @recruitment = Recruitment.find_by(id: params[:id])
    @recruitment.discard
    redirect_to("/recruitments/myrecruitments")
  end

  private
  def recruitment_params
    params.require(:recruitment).permit(:name, :overview, :target, :detail, :image, :image_cache, :tag, :tag_category_id).merge(user_id: current_user.id)
  end
end