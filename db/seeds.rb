require "csv"

CSV.foreach('db/seeds/csv/User.csv', headers: true) do |row|
  User.create(
    name: row['name'],
    email: row['email'],
    password: row['password'],
    admin: row['admin'],
    icon: row['icon']
  )
end

CSV.foreach('db/seeds/csv/Post.csv', headers: true) do |row|
  Post.create(
    content: row['content'],
    user_id: row['user_id']
  )
end

CSV.foreach('db/seeds/csv/TagCategory.csv', headers: true) do |row|
  TagCategory.create(
    name: row['name']
  )
end

CSV.foreach('db/seeds/csv/Tag.csv', headers: true) do |row|
  Tag.create(
    name: row['name'],
    tag_category_id: row['tag_category_id']
  )
end

CSV.foreach('db/seeds/csv/Project.csv', headers: true) do |row|
  Project.create(
    name: row['name'],
    about: row['about']
  )
end

CSV.foreach('db/seeds/csv/Affiliation.csv', headers: true) do |row|
  Affiliation.create(
    project_id: row['project_id'],
    user_id: row['user_id'],
    is_master: row['is_master']
  )
end

CSV.foreach('db/seeds/csv/Recruitment.csv', headers: true) do |row|
  Recruitment.create(
    user_id: row['user_id'],
    project_id: row['project_id'],
    name: row['name'],
    overview: row['overview'],
    target: row['target'],
    detail: row['detail'],
    tag_id: row['tag_id'],
    is_published: row['is_published'],
    image: row['image']
  )
end

CSV.foreach('db/seeds/csv/Entry.csv', headers: true) do |row|
  Entry.create(
    user_id: row['user_id'],
    recruitment_id: row['recruitment_id'],
    content: row['content']
  )
end