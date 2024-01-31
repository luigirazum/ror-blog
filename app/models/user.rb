class User < ApplicationRecord
  # associations
  has_many :posts, foreign_key: 'author_id', inverse_of: :author
  has_many :comments, inverse_of: :user
  has_many :likes, inverse_of: :user

  # validations
  # name > can't be blank
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, length: {
    maximum: 80,
    too_long: "can't exceed %<count>s characters"
  }

  # posts_counter > must be an 'integer' 'greater than or equal' to 'zero'.
  validates :posts_counter, presence: true
  validates :posts_counter, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  # custom methods
  # most_recent_posts > retrieves the 'n' most recent posts
  #  - by default it will return the 3 most recent posts
  def most_recent_posts(num = 3)
    posts.includes(comments: [:user]).order(created_at: :desc).limit(num)
  end
end
