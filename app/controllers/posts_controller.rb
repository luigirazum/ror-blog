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
    @post.author = current_user
    respond_to do |format|
      format.html { render :new, locals: { post: @post } }
    end
  end

  def create
    @post = Post.new(post_params)
    @post.author = current_user
    respond_to do |format|
      format.html do
        if @post.save
          # redirect to index
          redirect_to user_posts_path(@post.author), notice: 'The Post was published successfully.'
        else
          # error message
          flash[:alert] = @post.errors.full_messages.first
          # render new
          redirect_back_or_to(new_post_url(@post))
        end
      end
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
