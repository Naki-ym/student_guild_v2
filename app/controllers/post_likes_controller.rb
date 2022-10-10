class PostLikesController < ApplicationController
  before_action :post_params

  def create
    @like = PostLike.new(user_id: current_user.id,  post_id: params[:post_id])
    @like.save
  end

  def destroy
    @like = PostLike.find_by(user_id: current_user.id, post_id: params[:post_id])
    @like.destroy
  end

  private

  def post_params
    @post = Post.find_by(id: params[:post_id])
  end
end
