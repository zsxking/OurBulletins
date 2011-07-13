class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  email_regex = /\A[\w]+[\w+\-.]*@[\w]+[.\-[\w]+]*\.edu\z/i
  password_regex = /^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E])+$/

  validates_presence_of :name
  validates_format_of :email, { :with => email_regex, :allow_blank => true,
                                :message => ' must end with .edu.' }
  validates_format_of :password, {:with => password_regex, :allow_blank => true,
                                  :message => 'must contain both numbers and letters.'}

  has_many :listings
end
