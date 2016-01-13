class FavoriteRelationshipsController < ApplicationController
    
  def create_each_id
    @micropost = Micropost.find(params[:micropost_id])
    current_user.like(@micropost)
  end

  def destroy_each_id
    @micropost = Micropost.find(params[:id])
    current_user.unlike(@micropost)
  end
end
