class CommentsController < ApplicationController
  def new
    @comment = Comment.new
    @post = Post.find(params[:post_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end
end
