class ProjectPost < ApplicationRecord
  include Discard::Model

  validates :content, {presence: true, length: {maximum: 200}}
  validates :project_id, {presence: true}
  validates :user_id, {presence: true}

  belongs_to :project
  belongs_to :user
end
