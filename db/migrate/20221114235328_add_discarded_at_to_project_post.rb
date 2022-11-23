class AddDiscardedAtToProjectPost < ActiveRecord::Migration[6.1]
  def change
    add_column :project_posts, :discarded_at, :datetime
    add_index :project_posts, :discarded_at
  end
end
