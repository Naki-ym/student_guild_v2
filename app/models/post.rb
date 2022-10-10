class Post < ApplicationRecord
  include Discard::Model

  validates :content, {presence: true, length: {maximum: 200}}
  validates :user_id, {presence: true}

  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user

  def user
    return User.find_by(id: self.user_id)
  end
  def likes
    return PostLike.where(post_id: self.id)
  end
end
