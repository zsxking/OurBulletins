class HomeController < ApplicationController
  def index
    if !user_signed_in?
      redirect_to new_user_registration_path
    end
  end

  def contact
    @title = "Contact Us"
  end

  def about
    @title = "About Us"
  end

  def help
    @title = "Help"
  end

end
