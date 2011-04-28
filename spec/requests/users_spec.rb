require 'spec_helper'

describe "Users" do

  describe "signup" do

    describe "failure" do

      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => ""
          fill_in "Email",        :with => ""
          fill_in "Password",     :with => ""
          fill_in "Confirmation", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end

    describe "success" do

      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => "Example User"
          fill_in "Email",        :with => "user@university.edu"
          fill_in "Password",     :with => "asdf1234"
          fill_in "Confirmation", :with => "asdf1234"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end

  end

  describe "sign in/out" do

    describe "failure" do
      it "should not sign a user in" do
        integration_sign_in '', ''
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end

    describe "success" do
      it "should sign a user in and out" do
        user = Factory(:user)
        integration_sign_in user.email, user.password
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end
  end

  describe "deactivate and reactivate" do
    describe "success" do
      it "should deactivate and reactivate the user" do
        user = Factory(:user)
        integration_sign_in user.email, user.password
        controller.should be_signed_in
        click_link "Profile"
        click_button "Deactivate"
        controller.should_not be_signed_in
        response.should have_selector("div.flash", :content => 'deactivated')
        integration_sign_in user.email, user.password
        controller.should be_signed_in
        response.should have_selector("div.flash", :content => 'reactivated')

      end
    end
  end

end
