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

  ## These follow, unfollow, follows methods will return user objects.
  ## The commented out alternatives below return relationship objects.
  ## Either version works fine to follow, unfollow, or check if one user follows another.

  ## For the "list a user's followers" view, you don't need these methods,
  ## you can just iterate over @user.followers and print the username for
  ## each follower with a link to their shouts page or similar.

  def follow!(user)
    self.following.where("relationships.followed_id => ?", user.id).first_or_create!
  end

  def unfollow!(user)
    # NOTE: This throws an exception if we aren't following user
    self.following.where("relationships.followed_id" => user.id).destroy!
  end

  def follows?(user)
    self.following.include?(user)
  end

  # Alternately
  # def follows?(other_user)
  #   self.relationships.find_by(followed_id: other_user.id)
  # end

  # def follow!(other_user)
  #   self.relationships.create!(followed_id: other_user.id)
  # end

  # def unfollow!(other_user)
  #   self.relationships.find_by(followed_id: other_user.id).destroy
  # end
end
