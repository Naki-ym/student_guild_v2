class AddImageToRecruitments < ActiveRecord::Migration[6.1]
  def change
    add_column :recruitments, :image, :string, null: false
  end
end
