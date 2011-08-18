require 'spec_helper'

describe "LayoutLinks" do
  describe "GET /layout_links" do

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

  end

  describe "when not logged in" do
    it "should have a login link" do
      visit root_path
      response.should have_selector("a", :href => new_user_session_path,
                                         :content => "Sign in")
    end
  end

  describe "when logged in " do

    before(:each) do
      @user = Factory(:user)
      integration_login @user.email, @user.password
    end

    it "should have a logout link" do
      visit root_path
      response.should have_selector("a", :href => destroy_user_session_path,
                                         :content => "Sign out")
    end

    it "should have a profile link" do
      visit root_path
      response.should have_selector("a", :href => edit_user_registration_path(@user),
                                         :content => "Profile")
    end

  end

end

