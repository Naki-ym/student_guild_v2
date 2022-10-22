class Room < ApplicationRecord
  include Discard::Model

  validates :name, {presence: true, length: {maximum: 30}}

  has_many :room_users
  has_many :users, through: :room_users
  has_many :messages

  def joinning_members(user) #引数に入れたユーザーは除外される
    users = self.users
    users = users.where.not(id: user.id)
    return users
  end
end
