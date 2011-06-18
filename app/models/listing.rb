class Listing < ActiveRecord::Base
  attr_accessible :title, :price, :description

  belongs_to :user
  belongs_to :saleable, :polymorphic => true

  validates :title,       :presence => true, :unless => :saleable?
  validates :price,       :presence => true,
                          :numericality => true
  validates :description, :presence => true

  default_scope :order => 'listings.created_at DESC'
  named_scope :other, :conditions => {:saleable_id => nil}

  private
    def saleable?
      !self.saleable_id.nil?
    end
end
