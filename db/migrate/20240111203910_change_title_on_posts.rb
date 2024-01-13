class ChangeTitleOnPosts < ActiveRecord::Migration[7.1]
  def change
    change_column :posts, :title, :string, limit: 250
  end
end
