class PostsController < ApplicationController
  def index
    session[:previous_url] = request.original_url
    @user = User.includes(posts: [comments: [:user]]).find(params[:user_id])
    @pagy, @posts = pagy(@user.posts.includes(comments: [:user]).order(created_at: :desc))
  end

  def show
    session[:previous_url] = request.original_url
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
    @author = current_user
    @post.author = current_user
    respond_to do |format|
      format.html { render :new, locals: { post: @post } }
    end
  end

  def create
    @post = Post.new(post_params)
    @author = current_user
    @post.author = current_user
    respond_to do |format|
      format.html do
        if @post.save
          # redirect to index
          redirect_to user_posts_path(@author), notice: 'The Post was published successfully.'
        else
          # error message
          flash[:alert] = @post.errors.full_messages.first
          # render new
          redirect_back_or_to(new_user_post_path(@author))
        end
      end
    end
  end

  def destroy
    flash[:alert] = "Delete post #{params[:id]}"
    redirect_back_or_to(root_url)
  end

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
