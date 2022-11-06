class Tag < ApplicationRecord
  include Discard::Model

  validates :name, {presence: true, length: {maximum: 30}}

  belongs_to :tag_category
  has_many :recruitments

  def category
    return TagCategory.kept.find_by(id: self.tag_category_id)
  end

  def recruitments(user_id)
    recruitments = Recruitment.kept.where(tag_id: self.id, is_published: true).where.not(user_id: user_id)
    return recruitments
  end
end
