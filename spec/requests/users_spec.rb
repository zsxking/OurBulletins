require 'spec_helper'

describe "Users" do

  describe "signup" do

    describe "failure" do

      it "should not make a new user" do
        lambda do
          visit new_user_registration_path
          fill_in "Name",         :with => ""
          fill_in "Email",        :with => ""
          fill_in "Password",     :with => ""
          fill_in "Password confirmation", :with => ""
          click_button 'Sign up'
          response.should render_template('devise/registrations/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end

    describe "success" do

      it "should make a new user" do
        lambda do
          visit new_user_registration_path
          fill_in "user_name",         :with => "Example User"
          fill_in "user_email",        :with => "user@university.edu"
          fill_in "user_password",     :with => "asdf1234"
          fill_in "user_password_confirmation", :with => "asdf1234"
          click_button 'Sign up'
          response.should have_selector("div.flash.notice",
                                        :content => "signed up successfully")
        end.should change(User, :count).by(1)
      end
    end

    it "should accessible from login page" do
      visit root_path
      click_link "Sign in"
      click_link "Sign up"
      response.should have_selector("h2",
                                    :content => "Sign up")
    end

  end

  describe "login/logout" do

    describe "failure" do
      it "should not login a user" do
        integration_login '', ''
        response.should have_selector("div.flash.alert", :content => "Invalid")
      end
    end

    describe "success" do
      it "should log a user in and out" do
        user = Factory(:user)
        integration_login user.email, user.password
        controller.should be_user_signed_in
        # disable following step because of javascript not running here.
        #click_link "Sign out"
        #controller.should_not be_user_signed_in
      end
    end
  end

  #describe "deactivate and reactivate" do
  #  describe "success" do
  #    it "should deactivate and reactivate the user" do
  #      user = Factory(:user)
  #      integration_login user.email, user.password
  #      controller.should be_user_signed_in
  #      click_link "Profile"
  #      click_button "Deactivate"
  #      controller.should_not be_user_signed_in
  #      response.should have_selector("div.flash", :content => 'deactivated')
  #      integration_login user.email, user.password
  #      controller.should be_user_signed_in
  #      response.should have_selector("div.flash", :content => 'reactivated')
  #
  #    end
  #  end
  #end

end

