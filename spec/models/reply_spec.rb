require 'spec_helper'

describe Reply do
  before (:each) do
    @listing = Factory(:listing)
    @user = Factory(:user)
  end

  it "should create a new instance of reply" do
    reply = @listing.replies.new(:message => 'Hi there')
    reply.user = @user
    reply.save!
  end

  describe 'Validation' do
    it 'should require a user' do
      reply = @listing.replies.new()
      reply.should_not be_valid
    end

    it 'should require a listing' do
      reply = Reply.new
      reply.user = @user
      reply.should_not be_valid
    end

    it 'should forbid assign user from mass assignment' do
      reply = @listing.replies.new({:user => @user})
      reply.user.should be_nil
    end

    it 'should forbid assign listing from mass assignment' do
      reply = Reply.new({:listing => @listing})
      reply.listing.should be_nil
    end

  end

end
