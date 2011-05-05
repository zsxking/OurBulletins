class SessionsController < ApplicationController

  def new
    @title = "Login"
  end

  def create

    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      # Create an error message and re-render the login form.
      login_error "Invalid email/password combination."
    elsif [UserStatus::ACTIVE, UserStatus::DEACTIVATED].include?(user.status)
      if user.status == UserStatus::DEACTIVATED
        user.update_attribute(:status, UserStatus::ACTIVE)
        flash[:success] = "Welcome back, #{user.name}.
                           Your #{app_name} account has now been reactivated."
      end
      # Log the user in and redirect to the user's show page.
      login user, params[:session][:remember_me]
      redirect_back_or user
    else
      # status == Banned
      login_error "Your account has been banned."
    end


  end

  def destroy

    logout
    redirect_to root_path
  end

  private

    def login_error(message)
      flash.now[:error] = message
      @title = "Login"
      render 'new'
    end

end
