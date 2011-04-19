require 'spec_helper'
require 'factories'

describe UsersController do
  render_views

  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
      # stubbing with the stub! method.
      # User.stub!(:find, @user.id).and_return(@user)
    end

    it "should be successful" do
      get :show, :id => @user # same as @user.id, because Rails will convert it.
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user.id
      #　The assigns method takes in a symbol argument and returns the value
      #　of the corresponding instance variable in the controller action.
      assigns(:user).should == @user
    end

    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar")
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => 'Sign Up')
    end

  end
end