class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :post_tags
  has_many :tags, through: :post_tags
  paginates_per 10

  def tag_names
    self.tags.map(&:name).join(', ')
  end

  def tag_names=(tags)
    self.tags = tags.split(',').map do |name|
      Tag.where(:name => name.strip).first_or_create!
    end
  end

  # Alternately:
  # all_tags = tags.split(',').map { |name| name.strip }
  # tag_models = all_tags.map { |name| Tag.where(:name => name).first_or_create! }
  # self.tags = tag_models
end
