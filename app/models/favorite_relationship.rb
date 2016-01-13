class FavoriteRelationship < ActiveRecord::Base

  belongs_to :user, class_name: "User"
  belongs_to :micropost, class_name: "Micropost"
  
end
