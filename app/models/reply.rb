class Reply < ActiveRecord::Base
  attr_accessible :message

  belongs_to :user
  belongs_to :listing

  validates_presence_of :user, :listing

end
