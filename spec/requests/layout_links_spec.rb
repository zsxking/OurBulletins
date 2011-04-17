require 'spec_helper'

describe "LayoutLinks" do
  describe "GET /layout_links" do

    it "should have a Home page at '/'" do
      get '/'
      response.should be_success
    end

    it "should have a Contact page at '/contact'" do
      get '/contact'
      response.should have_selector('title', :content => "Contact")
    end

    it "should have an About page at '/about'" do
      get '/about'
      response.should have_selector('title', :content => "About")
    end

    it "should have a Help page at '/help'" do
      get '/help'
      response.should have_selector('title', :content => "Help")
    end

    it "should have a signup page at '/signup'" do
      get '/signup'
      response.should have_selector('title', :content => "Sign Up")
    end

  end

  describe "Click /layout_links" do
    it "should have the right links on the layout" do
      visit root_path
      click_link "About"
      response.should have_selector('title', :content => "About")
      click_link "Help"
      response.should have_selector('title', :content => "Help")
      click_link "Contact"
      response.should have_selector('title', :content => "Contact")
      click_link "Sign Up"
      response.should have_selector('title', :content => "Sign Up")
      click_link "Home"
      response.should be_success
    end
  end
end
