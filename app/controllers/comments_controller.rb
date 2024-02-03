class CommentsController < ApplicationController
  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments

    respond_to do |format|
      format.html
      format.json { render json: @comments }
    end
  end

  def new
    @comment = Comment.new
    @post = Post.find(params[:post_id])
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        # success message
        format.html { redirect_to post_url(@post), notice: 'The Comment was published successfully.' }
        format.json { render json: @comment, status: :created }
      else
        flash[:alert] = @comment.errors.full_messages.first
        # render new
        format.html { redirect_back_or_to(new_post_comment_url(@post)) }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      flash[:notice] = "The comment ##{params[:id]} was successfully deleted."
    else
      flash[:alert] = 'Something went wrong while trying to delete the comment.'
    end

    redirect_back_or_to(session[:previous_url])
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end
end
