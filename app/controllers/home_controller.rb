class HomeController < ApplicationController
  def index
    redirect_to books_path
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
