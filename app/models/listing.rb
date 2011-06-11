class Listing < ActiveRecord::Base
  attr_accessible :title, :category, :price, :description

  belongs_to :user

  validates :title,       :presence => true
  validates :category,    :presence => true
  validates :price,       :presence => true
  validates :description, :presence => true

  default_scope :order => 'listings.created_at DESC'

end
