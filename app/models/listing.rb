class Listing < ActiveRecord::Base
  attr_accessible :title, :price, :description

  belongs_to :user
  belongs_to :saleable, :polymorphic => true

  validates :title,       :presence => true
  validates :price,       :presence => true
  validates :description, :presence => true

  default_scope :order => 'listings.created_at DESC'

end
