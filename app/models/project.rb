class Project < ApplicationRecord
  include Discard::Model

  validates :name, {presence: true, length: {maximum: 200}}
  validates :about, {presence: true}

  has_many :affiliations
  has_many :users, through: :affiliations
  has_many :recruitments

  def join?(user)
    if self.users.find_by(id: user.id)
      return true
    end
  end
end
