class Reply < ActiveRecord::Base
  attr_accessible :message

  belongs_to :user
  belongs_to :listing

  validates_associated :user, :listing
  validates_presence_of :user, :listing

end
