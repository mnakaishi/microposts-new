class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  validates :region, presence: true, length: { maximum: 20 }, on: :update
  validates :profile, length: { maximum: 400 }
  
  has_many :microposts
  
  has_many :following_relationships, class_name:  "Relationship",
                                     foreign_key: "follower_id",
                                     dependent:   :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  
  has_many :follower_relationships, class_name:  "Relationship",
                                    foreign_key: "followed_id",
                                    dependent:   :destroy
  has_many :follower_users, through: :follower_relationships, source: :follower
  
  
    # 他のユーザーをフォローする
  def follow(other_user)
    following_relationships.find_or_create_by(followed_id: other_user.id)
  end

  # フォローしているユーザーをアンフォローする
  def unfollow(other_user)
    following_relationship = following_relationships.find_by(followed_id: other_user.id)
    following_relationship.destroy if following_relationship
  end

  # あるユーザーをフォローしているかどうか？
  def following?(other_user)
    following_users.include?(other_user)
  end
  
  def feed_items
    Micropost.where(user_id: following_user_ids + [self.id])
  end
  
  mount_uploader :image, ImageUploader
  
 # favorite
 has_many :favorites
 has_many :favorite_microposts, class_name: "Micropost", through: :favorites, source: :micropost 
 
 
  # retweet 
  # あるユーザーが、リツイートしたつぶやき
  has_many :user_retweet_relations, class_name: "Retweet",
                                     foreign_key: "user_id",
                                     dependent:   :destroy
  has_many :user_retweets, through: :user_retweet_relations, source: :micropost
  
  # あるつぶやきをリツイートしている人
  has_many :retweet_user_relations, class_name: "Retweet",
                                     foreign_key: "micropost_id",
                                     dependent:   :destroy
  has_many :retweeted_users, through: :retweet_user_relations, source: :user
  
    # register retweet 
  def retweet(id)
    user_retweet_relations.create(micropost_id: id)
  end

  # cancel retweet
  def unretweet(id)
    Retweet.find_by(id:id).destroy
  end

  # check if retweeted?
  def retweeted?(micropost)
    user_retweets.include?(micropost)
  end
  
  
  # favorite
  def favorite(micropost)
    favorites.create(micropost_id: micropost.id)
  end
  def unfavorite(micropost)
    favorites.find_by(micropost_id: micropost.id).destroy
  end
  def favorite?(micropost)
    favorite_microposts.include?(micropost)
  end 
end
