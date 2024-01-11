class ModifyColumnsNulltoTables < ActiveRecord::Migration[7.1]
  def change
    change_column_null :users, :name, false
    change_column_null :users, :posts_counter, false
    change_column_null :comments, :text, false
    change_column_null :posts, :title, false
    change_column_null :posts, :text, false
    change_column_null :posts, :comments_counter, false
    change_column_null :posts, :likes_counter, false
  end
end
