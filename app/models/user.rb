class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :post_likes, dependent: :destroy
  has_many :likes_posts, through: :post_likes, source: :post #いいねした投稿
  has_many :room_users
  has_many :rooms, through: :room_users
  has_many :messages
  has_many :affiliations
  has_many :projects, through: :affiliations
  has_many :recruitments
  has_many :entries

  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following_user, through: :follower, source: :followed # 自分がフォローしている人
  has_many :follower_user, through: :followed, source: :follower # 自分をフォローしている人

  mount_uploader :icon, IconUploader

  #いいねされている？
  def liked_by?(post_id)
    post_likes.where(post_id: post_id).exists?
  end

  # ユーザーをフォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # フォローしていればtrueを返す
  def following?(user)
    following_user.include?(user)
  end

  # フォローしているユーザー
  def followings
    return self.following_user
  end

  def project_member?(project)
    @project = Affiliation.find_by(project_id: project.id, user_id: self.id)
    if @affiliation.is_master
      return true
    end
  end

  def project_master?(project)
    @affiliation = Affiliation.find_by(project_id: project.id, user_id: self.id)
    if @affiliation.is_master
      return true
    end
  end

  def affiliation(project)
    return self.affiliations.find_by(project_id: project.id)
  end

  #所属している全ての個人チャットを返す
  def joinning_individual_rooms
    rooms = self.rooms.where(is_group_chat: false)
    return rooms
  end

  def connected?(current_user)
    #所属の部屋を取得
    rooms = self.rooms.where(is_group_chat: false)
    user_ids = []
    #所属しているチャットの相手のidを取得して配列へ
    rooms.each do |room|
      users = room.joinning_members(self)
      users.each do |user|
        if user.id != self.id
          user_ids << user.id
        end
      end
    end
    #そこに自分がいればtrueを返す
    if user_ids.include?(current_user.id)
      true
    end
  end

  #その相手と個人チャットしているときそのidを返す
  def connected_individual_room(current_user)
    #所属の部屋を取得
    user_rooms         = self.rooms.where(is_group_chat: false)
    current_user_rooms = current_user.rooms.where(is_group_chat: false)
    room = user_rooms & current_user_rooms
    return room
  end
end
