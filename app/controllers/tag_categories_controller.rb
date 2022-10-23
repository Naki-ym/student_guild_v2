class TagCategoriesController < ApplicationController
  #管理者アカウントのみがアクセスできる
  before_action :admin_user

  def index
    @categories = TagCategory.kept.order(created_at: :asc)
    @sort_list = {"作成順（古い順）": 1, "作成順（新しい順）": 2, "名前順": 3}
  end

  def sort
    case params[:sort].to_i
    when 1
      @categories = TagCategory.kept.order(created_at: :asc)
    when 2
      @categories = TagCategory.kept.order(created_at: :desc)
    when 3
      @categories = TagCategory.kept.order(name: :asc, created_at: :asc)
    else
      @categories = TagCategory.kept.order(created_at: :asc)
    end
  end

  def create
    @category = TagCategory.new(category_params)
    if @category.save
      redirect_to("/tag_categories")
    else
      render("tag_categories/new")
    end
  end

  def new
    @category = TagCategory.new
  end

  def edit
    @category = TagCategory.find_by(id: params[:id])
  end
  
  def update
    @category = TagCategory.find_by(id: params[:id])
    if @category.update(category_params)
      redirect_to("/tag_categories")
    else
      render("tag_categories/edit")
    end
  end

  def destroy
    @category = TagCategory.kept.find_by(id: params[:id])
    @category.discard
    redirect_to("/tag_categories")
  end

  private
  def category_params
    params.require(:tag_category).permit(:name)
  end
end
