class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :trackable and :omniauthable
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable, :timeoutable

  has_many :posts, dependent: :destroy
  has_many :post_likes, dependent: :destroy
  #いいねした投稿
  has_many :likes_posts, through: :post_likes, source: :post

  #いいねされている？
  def liked_by?(post_id)
    post_likes.where(post_id: post_id).exists?
  end
end
