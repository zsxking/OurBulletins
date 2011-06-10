# == Schema Information
# Schema version: 20110419020858
#
# Table name: users
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)
#  email              :string(255)
#  encrypted_password :string(255)
#  salt               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#


module UserStatus
  PENDING = 0
  ACTIVE = 1
  DEACTIVATED = 2
  BANNED = 3
end

class User < ActiveRecord::Base
  attr_accessor :password
  # Only these attributes have getter and setter for outside access.
  attr_accessible :name, :email, :password, :password_confirmation

  has_many :listings


  email_regex = /\A[\w]+[\w+\-.]*@[\w]+[.\-[\w]+]*\.edu\z/i
  password_regex = /^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E])+$/

  validates :name,  :presence   => true
  validates :email, :presence   => true,
                    :format     => { :with => email_regex,
                                     :message => ' must end with .edu.' },
                    :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :minimum => 8 },
                       :format => { :with => password_regex,
                                    :message => 'must contain both a number
                                                 and a letter.'}
  validates :status, :inclusion => [UserStatus::PENDING,
                                    UserStatus::ACTIVE,
                                    UserStatus::DEACTIVATED,
                                    UserStatus::BANNED,
                                    ]

  default_scope :conditions => { :status => UserStatus::ACTIVE}

  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    self.encrypted_password == encrypt(submitted_password)
  end


  def self.authenticate(email, submitted_password)
    user = User.unscoped.find_by_email(email.downcase)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
    #automatically returns nil at the end of the method.
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  before_save :encrypt_password
  before_save :lowercase_email

  # all methods defined after private are private methods
  private

    def lowercase_email
      self.email = self.email.downcase
    end

    def encrypt_password
      self.salt = make_salt if self.new_record?
      self.encrypted_password = encrypt(self.password) if !self.password.nil?
    end

    def encrypt(string)
      secure_hash("#{self.salt}::#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}::#{self.password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
