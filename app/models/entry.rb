class Entry < ApplicationRecord
  include Discard::Model

  validates :user_id, {presence: true}
  validates :recruitment_id, {presence: true}
  validates :content, {presence: true}

  belongs_to :user
  belongs_to :recruitment

  def user
    return User.find_by(id: self.user_id)
  end
end