require 'spec_helper'

describe Post do
  before (:each) do
    @user = Factory(:user)
    @attr = {:title => "Test Post", :category => "Textbook",
             :description => "content of the description"}
  end

  it "should create a new instance given valid attributes" do
    @user.posts.create!(@attr)
  end

  describe "user associations" do
    before(:each) do
      @post = @user.posts.create!(@attr)
    end

    it "should have a user attribute" do
      @post.should respond_to :user
    end

    it "should have the right associated user" do
      @post.user_id.should == @user.id
      @post.user.should == @user
    end
  end

  describe "Validation" do
    it "should require a title" do
      post = @user.posts.new(@attr.merge(:title => ""))
      post.should_not be_valid
    end

    it "should require a category" do
      post = @user.posts.new(@attr.merge(:category => ""))
      post.should_not be_valid
    end

    it "should require a description" do
      post = @user.posts.new(@attr.merge(:description => ""))
      post.should_not be_valid
    end
  end

end
