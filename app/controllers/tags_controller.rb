class TagsController < ApplicationController
  #管理者アカウントのみがアクセスできる
  before_action :admin_user

  def index
    @tags = Tag.kept.order(created_at: :asc)
    @sort_list = {"作成順（昇順）": 1, "作成順（降順）": 2, "カテゴリ順": 3, "名前順": 4}
  end
  
  def sort
    case params[:sort].to_i
    when 1
      @tags = Tag.kept.order(created_at: :asc)
    when 2
      @tags = Tag.kept.order(created_at: :desc)
    when 3
      @tags = Tag.kept.order(tag_category_id: :asc, created_at: :asc)
    when 4
      @tags = Tag.kept.order(name: :asc, created_at: :asc)
    else
      @tags = Tag.kept.order(created_at: :asc)
    end
  end
  
  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to("/tags")
    else
      @categories = TagCategory.kept.order(created_at: :asc)
      render("tags/new")
    end
  end
  
  def new
    @tag = Tag.new
    @categories = TagCategory.kept.order(created_at: :asc)
  end
  
  def edit
    @tag  = Tag.kept.find_by(id: params[:id])
    @category = @tag.category
    @categories = TagCategory.kept.order(created_at: :asc)
  end
  
  def update
    @tag  = Tag.kept.find_by(id: params[:id])
    if @tag.update(tag_params)
      redirect_to("/tags")
    else
      @category = @tag.category
      @categories = TagCategory.kept.order(created_at: :asc)
      render("tags/edit")
    end
  end
  
  def destroy
    @tag = Tag.kept.find_by(id: params[:id])
    @tag.discard
    redirect_to("/tags")
  end

  private
  def tag_params
    params.require(:tag).permit(:name, :tag_category_id)
  end
end
