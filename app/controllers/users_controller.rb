class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show]
  before_action :authorization, only: [:edit, :update, :show]

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(created_at: :desc)
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
  
  
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :region, :profile)
  end
end

