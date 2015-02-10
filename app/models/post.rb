class Post < ActiveRecord::Base
  belongs_to :user
  has_many :tags, through: :post_tags
end
