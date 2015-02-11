class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts

  has_many :relationships, foreign_key: "follower_id"
  has_many :following, through: :relationships, source: :followed

  has_many :reverse_relationships, foreign_key: "followed_id",
           class_name: "Relationship"
  has_many :followers, through: :reverse_relationships, source: :follower

  validates :username, presence: true, uniqueness: true,
            format: { with: /[a-zA-Z0-9]{4,20}/,
                      message: "must be between 4 and 20 alphanumerics." }

  def follow(user)
    self.following.where(:followed_id => user.id).first_or_create!
  end

  def unfollow(user)
    # TODO: This breaks if we aren't following user
    self.following.where(:followed_id => user.id).destroy!
  end

  def follows?(user)
    self.following.include?(user)
  end
end
