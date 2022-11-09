class AddDiscardedAtToAffiliation < ActiveRecord::Migration[6.1]
  def change
    add_column :affiliations, :discarded_at, :datetime
    add_index :affiliations, :discarded_at
  end
end
