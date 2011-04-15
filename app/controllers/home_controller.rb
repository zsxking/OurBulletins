class HomeController < ApplicationController
  def index
  end

  def contact
    @title = "Contact Us"
  end

  def about
    @title = "About Us"
  end
end
