class CommentsController < ApplicationController
  def new
    @comment = Comment.new
    @post = Post.find(params[:post_id])
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      # success message
      redirect_to user_post_url(@post.author, @post), notice: 'The Comment was published successfully.'
    else
      flash[:alert] = @comment.errors.full_messages.first
      # render new
      redirect_back_or_to(new_comment_url(@post))
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end
end
