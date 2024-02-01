class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @like = @post.likes.build(user: current_user)
    if @like.save
      redirect_to user_posts_path(@post.author), notice: 'You Liked the post successfully.'
    else
      # error message
      flash[:alert] = 'Unable to give a like to the post.'
      redirect_to user_posts_path(@post.author)
    end
  end
end
