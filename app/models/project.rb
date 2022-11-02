class Project < ApplicationRecord
  include Discard::Model

  validates :user_id, {presence: true}
  validates :tag_id, {presence: true}
  validates :name, {presence: true, length: {maximum: 200}}
  validates :overview, {presence: true, length: {maximum: 200}}
  validates :target, {presence: true, length: {maximum: 200}}
  validates :detail, {presence: true}

  belongs_to :user
  belongs_to :tag
  has_many :entries

  mount_uploader :image, ProjectImageUploader

  def tag
    return Tag.find_by(id: self.tag_id)
  end

  def user
    return User.find_by(id: self.user_id)
  end
end
