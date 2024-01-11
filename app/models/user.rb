class User < ApplicationRecord
  has_many :posts, foreign_key: 'author_id', inverse_of: 'author'
  has_many :comments
  has_many :likes

  def most_recent_posts(num = 3)
    posts.order(created_at: :desc).limit(num)
  end
end
