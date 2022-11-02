class Tag < ApplicationRecord
  include Discard::Model

  validates :name, {presence: true, length: {maximum: 30}}

  belongs_to :tag_category
  has_many :projects

  def category
    return TagCategory.kept.find_by(id: self.tag_category_id)
  end

  def projects(user_id)
    projects = Project.kept.where(tag_id: self.id, is_published: true).where.not(user_id: user_id)
    return projects
  end
end
