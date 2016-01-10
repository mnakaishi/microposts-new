class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed_items.includes(:user).order(created_at: :desc)
      @feed_items = Micropost.page(params[:page]).per(5).order(created_at: :desc) #paginate
    end
  end
end