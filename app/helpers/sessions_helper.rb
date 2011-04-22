module SessionsHelper

  def sign_in(user)
    # cookies utility supplied by Rails.
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    # create current_user, accessible in both controllers and views
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  private

    def user_from_remember_token
      # the * operator, allows us to use a two-element array as an argument
      # to a method expecting two variables
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

end
