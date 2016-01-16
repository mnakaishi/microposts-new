class RetweetsController < ApplicationController

  before_action :logged_in_user

  def create
    @micropost = Micropost.find_by(id: params[:micropost_id])
    @count = Retweet.where(micropost_id: params[:micropost_id]).count
    puts @count
    
    
    @additional_comment = ""
    if @count < 1
      @additional_comment = "#{@micropost.user.name}さんのつぶやきをリツイートしました："
    end

    save_content = @additional_comment + @micropost.content 
    @retweet_micropost = Micropost.new(:user_id => current_user.id, :content => save_content)
    
    if @retweet_micropost.save
      flash[:success] = "Micropost retweeted!"
      current_user.retweet(@retweet_micropost.id)
    end

    redirect_to request.referrer || root_url
  end

  def destroy
    @target_tweet = Retweet.find_by(id: params[:id])
    current_user.unretweet(@target_tweet)
    Micropost.find_by(id: @target_tweet.micropost_id).destroy

    redirect_to request.referrer || root_url
  end
end
