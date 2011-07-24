require 'spec_helper'

describe Listing do
  before (:each) do
    @user = Factory(:user)
    @attr = {:title => "Test Listing", :price => 1234,
             :description => "content of the description", :condition => 'Like New'}
  end

  it "should create a new instance given valid attributes" do
    @user.listings.create!(@attr)
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

    it "should require a price" do
      listing = @user.listings.new(@attr.merge(:price => nil))
      listing.should_not be_valid
    end

    it "should require a description" do
      listing = @user.listings.new(@attr.merge(:description => " "))
      listing.should_not be_valid
    end

    it "should require a condition" do
      listing = @user.listings.new(@attr.merge(:condition => " "))
      listing.should_not be_valid
    end

    it "should reject condition values that not in CONDITION_LIST" do
      listing = @user.listings.new(@attr.merge(:condition => "Old"))
      listing.should_not be_valid
    end
  end

  describe "polymorphic association" do

    it "should response to saleable" do
      listing = Listing.create!(@attr)
      listing.should respond_to :saleable
    end

  end

end
