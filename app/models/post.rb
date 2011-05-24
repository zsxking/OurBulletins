class Post < ActiveRecord::Base
  attr_accessible :title, :category, :description

  belongs_to :user

  validates :title,       :presence => true
  validates :category,    :presence => true
  validates :description, :presence => true

  default_scope :order => 'posts.created_at DESC'

end
