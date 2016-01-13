  # star function
  belongs_to :user
  has_many :stars, :dependent => :destroy
  has_many :stared_users, :through => :stars, :source => :user