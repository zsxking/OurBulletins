require 'spec_helper'

describe "FriendlyForwardings" do
  it "should forward to the requested page after login" do
    user = Factory(:user)
    visit edit_user_registration_path(user)
    # The test automatically follows the redirect to the login page.
    # so the response.should redirect_to some URL won’t work.
    response.should have_selector "h2", :content => "Sign in"
    fill_in :email,    :with => user.email
    fill_in :password, :with => user.password
    click_button 'Login'
    # The test follows the redirect again, this time to users/edit.
    response.should render_template('users/edit')
  end
end
