class UsersController < ApplicationController
  def index
    session[:previous_url] = request.original_url
    @users = User.accessible_by(current_ability).all
  end

  def show
    session[:previous_url] = request.original_url
    @user = User.accessible_by(current_ability).find(params[:id])
    @pagy, @posts = pagy(@user.most_recent_posts)
  end
end
