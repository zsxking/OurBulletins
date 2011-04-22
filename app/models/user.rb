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

class User < ActiveRecord::Base
  attr_accessor :password
  # Only these attributes have getter and setter for outside access.
  attr_accessible :name, :email, :password, :password_confirmation

  email_regex = /\A[\w]+[\w+\-.]*@[\w]+[.\-[\w]+]*\.edu\z/i
  password_regex = /^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E])+$/

  validates :name,  :presence   => true
  validates :email, :presence   => true,
                    :format     => { :with => email_regex,
                                     :message => ' must end with .edu.' },
                    :uniqueness => { :case_sensitive => false }
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :minimum => 8 },
                       :format       => { :with => password_regex,
                                          :message => 'must contain both a number and a letter.'}

  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    self.encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
    #automatically returns nil at the end of the method.
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  #use a before_save callback to create encrypted_password just before the user is saved.
  #we register a callback called encrypt_password by passing a symbol of that
  #name to the before_save method, and then define an encrypt_password method
  #to perform the encryption. With the before_save in place, Active Record will
  #automatically call the corresponding method before saving the record.
  before_save :encrypt_password

  # all methods defined after private are private methods
  private

    def encrypt_password
      self.salt = make_salt if self.new_record?
      self.encrypted_password = encrypt(self.password)
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
