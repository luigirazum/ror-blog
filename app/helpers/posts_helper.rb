module PostsHelper
  def render_all_posts
    if @posts.size.positive?
      render partial: 'posts/post', layout: 'post_comments', collection: @posts
    else
      render partial: 'empty', locals: { options: %w[user posts] }
    end
  end

  def render_comments(comments)
    if comments.size.positive?
      render partial: 'comments/comment', collection: comments
    else
      render partial: 'empty', locals: { options: %w[post comments] }
    end
  end
end
