class AddDiscardedAtToRecruitments < ActiveRecord::Migration[6.1]
  def change
    add_column :recruitments, :discarded_at, :datetime
    add_index :recruitments, :discarded_at
  end
end
