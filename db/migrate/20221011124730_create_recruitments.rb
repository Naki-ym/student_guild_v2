class CreateRecruitments < ActiveRecord::Migration[6.1]
  def change
    create_table :recruitments do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :overview, null: false
      t.string :target, null: false
      t.text :detail, null: false
      t.references :tag, null: false, foreign_key: true
      t.boolean :is_published, null: false, default: false

      t.timestamps
    end
  end
end
