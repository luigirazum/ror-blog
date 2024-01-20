class PostsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @posts = @user.posts.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
    @post.author = current_user
    respond_to do |format|
      format.html { render :new, locals: { post: @post } }
    end
  end
end
