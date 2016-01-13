class UsersController < ApplicationController
 before_action :set_user, only: [:edit, :update, :show]
 before_action :authorization, only: [:edit, :update]

  def show # 追加
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(created_at: :desc)
    @microposts = @microposts.page(params[:page]).per(5).order(created_at: :desc) #paginate
  end

  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def update # 追加
    if @user.update(user_params)
      flash[:success] = "profile updated"
      redirect_to user_path
    else
      render 'edit'
    end
  end
  
  def edit # 追加
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to root_url, alert: 'Non authorization'
    end
  end
  
  
  def set_user # 追加
     @user = User.find(params[:id])
  end
  
  def authorization # 追加
    if @user != current_user
      flash[:danger] = "Non authorization"
      redirect_to root_path
    end
  end
  
  def followings # 課題
    @user = User.find(params[:id])
    @following_users = @user.following_users
  #  render 'follow'
  end
  
  def followers # 課題
    @user = User.find(params[:id])
    @follower_users = @user.follower_users
    render 'follower'
  end
  
  def index
    @users = User.page(params[:page]).per(5).order(:id)
  end

  def favorites
    @user = User.find(params[:id])
    @favorite_microposts = @user.favorite_microposts
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :region, :profile, :image)
  end
end

