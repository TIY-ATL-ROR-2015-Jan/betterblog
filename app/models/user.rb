class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :posts

  validates :username, presence: true, uniqueness: true,
            format: { with: /[a-zA-Z0-9]{4,20}/,
                      message: "must be between 4 and 20 alphanumerics." }
end
