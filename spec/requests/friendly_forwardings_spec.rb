require 'spec_helper'

describe "FriendlyForwardings" do
  it "should forward to the requested page after login" do
    user = Factory(:user)
    user.confirm!
    listing = Factory(:listing)
    # Reply to a listing require user login.
    visit reply_listing_path(listing)
    # The test automatically follows the redirect to the login page.
    # so the response.should redirect_to some URL won't work.
    response.should render_template 'devise/sessions/new'
    fill_in :email,    :with => user.email
    fill_in :password, :with => user.password
    click_button 'Sign in'
    # The test follows the redirect again, this time to users/edit.
    response.should render_template('listings/new_reply')
  end
end

