require 'spec_helper'

describe Listing do
  before (:each) do
    @user = Factory(:user)
    @attr = {:title => "Test Listing", :category => "Textbook",
             :description => "content of the description"}
  end

  it "should create a new instance given valid attributes" do
    @user.listings.create(@attr)
  end

  describe "user associations" do
    before(:each) do
      @listing = @user.listings.create(@attr)
    end

    it "should have a user attribute" do
      @listing.should respond_to :user
    end

    it "should have the right associated user" do
      @listing.user_id.should == @user.id
      @listing.user.should == @user
    end
  end

  describe "Validation" do
    it "should require a title" do
      listing = @user.listings.new(@attr.merge(:title => " "))
      listing.should_not be_valid
    end

    it "should require a category" do
      listing = @user.listings.new(@attr.merge(:category => " "))
      listing.should_not be_valid
    end

    it "should require a description" do
      listing = @user.listings.new(@attr.merge(:description => " "))
      listing.should_not be_valid
    end
  end

end
