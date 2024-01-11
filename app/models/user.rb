class User < ApplicationRecord
  has_many :posts, foreign_key: 'author_id', inverse_of: 'author'
  has_many :comments
  has_many :likes
end
