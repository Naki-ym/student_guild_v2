class CreateProjectPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :project_posts do |t|
      t.string :content, null: false
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
