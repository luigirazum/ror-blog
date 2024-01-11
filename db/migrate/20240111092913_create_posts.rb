class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title, limit: 255
      t.text :text
      t.bigint :comments_counter
      t.bigint :likes_counter

      t.timestamps
    end
  end
end
