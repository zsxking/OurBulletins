module SessionsHelper

  def sign_in(user, remember_me = true)
    # cookies utility supplied by Rails.
    if remember_me
      cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    else
      cookies.delete(:remember_token)
      session[:remember_token] = [user.id, user.salt]
    end
    # create current_user, accessible in both controllers and views
    self.current_user = user
  end

  # Setter of current_user
  def current_user=(user)
    @current_user = user
  end

  # Getter of current_user
  def current_user
    @current_user ||= user_from_remember_token
  end

  # Check if the given user is the same as current login user.
  def current_user?(user)
    user == current_user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    session.delete(:remember_token)
    self.current_user = nil
  end

  def deny_access
    store_location
    # shortcut for setting flash[:notice]
    # by passing an options hash to the redirect_to function
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  private

    def user_from_remember_token
      # the * operator, allows us to use a two-element array as an argument
      # to a method expecting two variables
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || session[:remember_token] || [nil, nil]
    end

    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end

end
