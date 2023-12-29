class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :title, presence: true
      t.text :content, presence: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
