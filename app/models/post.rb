class Post < ApplicationRecord
  after_create :update_posts_counter
  after_destroy :update_posts_counter

  # associations
  belongs_to :author, class_name: 'User', foreign_key: 'author_id', inverse_of: 'posts', counter_cache: :posts_counter
  has_many :comments
  has_many :likes

  # validations
  # title > must not be blank and must not exceed 250 characters.
  validates :title, presence: true
  validates :title, length: {
    maximum: 250,
    too_long: "can't exceed %<count>s characters"
  }

  # comments_counter must be an integer greater than or equal to zero.
  validates :comments_counter, presence: true
  validates :comments_counter, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  # likes_counter must be an integer greater than or equal to zero.
  validates :likes_counter, presence: true
  validates :likes_counter, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }

  # custom methods
  # most_recent_comments > retrieves the 'n' most recent comments
  #  - by default it will return the 5 most recent comments
  def most_recent_comments(number = 5)
    comments.order(created_at: :desc).limit(number)
  end

  # update_posts_counter > updates how many posts a user has.
  def update_posts_counter
    author.update(posts_counter: author.posts.count)
  end
end
