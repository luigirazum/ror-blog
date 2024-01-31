class UsersController < ApplicationController
  def index
    session[:previous_url] = request.original_url
    @users = User.all
  end

  def show
    session[:previous_url] = request.original_url
    @user = User.find(params[:id])
    @pagy, @posts = pagy(@user.most_recent_posts)
  end
end
