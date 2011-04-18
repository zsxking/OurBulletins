# == Schema Information
# Schema version: 20110414085700
#
# Table name: users
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  # Only these attributes have getter and setter for outside access.
  attr_accessible :name, :email

  email_regex = /\A[\w_\-.]+[\w+\-.]+@hawaii\.edu\z/i

  validates :name,  :presence   => true
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }

end
