class Affiliation < ApplicationRecord
  include Discard::Model

  belongs_to :user
  belongs_to :project
end
