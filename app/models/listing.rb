class Listing < ActiveRecord::Base
  attr_accessible :title, :price, :description, :condition

  CONDITION_LIST = ['Brand New', 'Like New', 'Very Good', 'Good', 'Acceptable']

  belongs_to :user
  delegate :name, :to => :user, :prefix => true

  belongs_to :saleable, :polymorphic => true

  has_many :replies

  validates :title,       :presence => true, :unless => :saleable?
  validates :price,       :presence => true,
                          :numericality => true
  validates :description, :presence => true
  validates :condition,   :presence => true,
                          :inclusion => CONDITION_LIST

  default_scope :order => 'listings.created_at DESC'
  scope :other, :conditions => {:saleable_id => nil}

  # just include the Tanker module
  include Tanker

  # define the callbacks to update or delete the index
  # these methods can be called whenever or wherever
  # this varies between ORMs
  after_save :update_tank_indexes
  after_destroy :delete_tank_indexes

  # define the index by supplying the index name and the fields to index
  # this is the index name you create in the Index Tank dashboard
  # you can use the same index for various models Tanker can handle
  # indexing searching on different models with a single Index Tank index
  tankit OurBulletins::Application.config.tanker_index do
    indexes :title
    indexes :description
    # Feature not release yet, wait for later version of Tanker than 1.1.3
    #category :price
    #category :saleable
    #category :condition
  end

  def title
    self.title || self.saleable.title
  end

  private

    def update_tank_indexes
      super.update_tank_indexes unless ENV["RAILS_ENV"] == 'test'
    end

    def delete_tank_indexes
      super.delete_tank_indexes unless ENV["RAILS_ENV"] == 'test'
    end

    def saleable?
      !self.saleable_id.nil?
    end
end
