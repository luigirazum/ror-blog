module UsersHelper
  def render_posts
    if @posts.size.positive?
      render partial: 'posts/post', layout: 'post_border', collection: @posts
    else
      render partial: 'empty', locals: { options: %w[user posts] }
    end
  end
end
