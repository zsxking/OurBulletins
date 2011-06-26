require 'spec_helper'

describe ListingsController do
  render_views

  describe "Authentication" do

    before(:each) do
      @user = Factory(:user)
      @listing = Factory(:listing, :user => @user)
    end

    describe "for non-logged in user" do

      it "should deny access to new" do
        get :new
        response.should redirect_to(login_path)
      end

      it "should deny access to create" do
        post :create
        response.should redirect_to(login_path)
      end

      it "should deny access to update" do
        put :update, :id => @listing
        response.should redirect_to(login_path)
      end

      it "should deny access to edit" do
        get :edit, :id => @listing
        response.should redirect_to(login_path)
      end
    end

  end

  describe "GET 'index'" do
    before(:each) do
      @user1 = Factory(:user)
      @user2 = Factory(:user, :email => Factory.next(:email))
      @listing1 = Factory(:listing, :user => @user1)
      @listing2 = Factory(:listing, :user => @user2, :title => 'New Title')
      @listing3 = Factory(:listing, :user => @user1, :title => 'Book Listing')
      @listing3.saleable = Factory(:book)
      @listing3.save
    end

    it "should be successful" do
      get :index
      response.should be_success
    end

    it "should have the right title" do
      get :index
        response.should have_selector("title", :content => "Others")
    end

    it "should show listings" do
      get :index
      response.should have_selector("div.title", :content => @listing1.title)
      response.should have_selector("div.title", :content => @listing2.title)
    end

    it "should have link to listings" do
      get :index
      response.should have_selector("a", :href => "/listings/#{@listing1.id}")
      response.should have_selector("a", :href => "/listings/#{@listing2.id}")
    end

    it "should not show book listings" do
      get :index
      response.should_not have_selector("div.title", :content => @listing3.title)
    end

  end

  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
      @listing = Factory(:listing, :user => @user)
      @user2 = Factory(:user, :email => Factory.next(:email))
    end

    it "should be successful" do
      get :show, :id => @listing
      response.should be_success
    end

    it "should show listing's title" do
      get :show, :id => @listing
      response.should have_selector('div', :content => @listing.title)
    end

    it "should show edit link when login as owner" do
      test_login(@user)
      get :show, :id => @listing
      response.should have_selector('a', :content => 'Edit')
    end

    it "should not show edit link when not login" do
      get :show, :id => @listing
      response.should_not have_selector('a', :content => 'Edit')
    end

    it "should not show edit link when login as others" do
      test_login(@user2)
      get :show, :id => @listing
      response.should_not have_selector('a', :content => 'Edit')
    end
  end

  describe "GET 'new'" do
    before(:each) do
      @user = Factory(:user)
      test_login(@user)
    end

    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => 'New Listing')
    end

    it "should have the Sign up button" do
      get :new
      response.should have_selector("input[value='Listing']")
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @user = Factory(:user)
      test_login(@user)
    end
  describe "failure" do

      before(:each) do
        @attr = {:title => '', :description => ''}
      end

      it "should not create a listing" do
        lambda do
          post :create, :listing => @attr
        end.should_not change(@user.listings, :count)
      end

      it "should render the 'new' page" do
        post :create, :listing => @attr
        response.should render_template('new')
      end
    end

    describe "success" do

      before(:each) do
        @attr = {:title => 'Listing Title',
                :price => 123, :description => 'Description content'}
      end

      # Cannot use response.should be_success,
      # because it returns true if the response code is in the range 200-299.
      # But the create action redirects, so the response code gets set to 302,
      # thus the failure
      it "should create a listing" do
        lambda do
          post :create, :listing => @attr
        end.should change(@user.listings, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :listing => @attr
        response.should redirect_to(listing_path(assigns(:listing)))
      end

    end

  end

  describe "GET 'edit'" do
    before(:each) do
      @user = Factory(:user)
      @listing = Factory(:listing, :user => @user)
      test_login(@user)
    end

    it "should be successful" do
      get :edit, :id => @listing
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @listing
      response.should have_selector("title", :content => "Edit")
      response.should have_selector("title", :content => @listing.title)
    end

    describe "on other's listing" do
      before (:each) do
        @another_user = Factory(:user, :email => Factory.next(:email))
        @another_listing = Factory(:listing, :user => @another_user)
      end

      it "should redirect to listing show page" do
        get :edit, :id => @another_listing
        response.should redirect_to @another_listing
      end

      it "should have a flash error message" do
        put :update, :id => @another_listing, :listing => @attr
        flash[:error].should =~ /invalid/i
      end

    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @user = Factory(:user)
      @listing = Factory(:listing, :user => @user)
      test_login(@user)
    end


    describe "failure" do

      before(:each) do
        @attr = {:title => '', :price => nil, :description => ''}
      end

      it "should render the 'edit' page" do
        put :update, :id => @listing, :listing => @attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @listing, :listing => @attr
        response.should have_selector("title", :content => "Edit")
      end
    end

    describe "success" do

      before(:each) do
        @attr = {:title => 'New Title', :price => 123,
                :description => 'New Descriptions'}
      end

      it "should change the listing's description" do
        put :update, :id => @listing, :listing => @attr
        @listing.reload
        @listing.description.should == @attr[:description]
      end

      it "should redirect to the listing show page" do
        put :update, :id => @listing, :listing => @attr
        response.should redirect_to @listing
      end

      it "should have a flash message" do
        put :update, :id => @listing, :listing => @attr
        flash[:success].should =~ /updated/i
      end
    end

    describe "on other's listing" do
      before (:each) do
        @another_user = Factory(:user, :email => Factory.next(:email))
        @another_listing = Factory(:listing, :user => @another_user)
        @attr = {:title => 'New Title',
                :description => 'New Descriptions'}
      end

      it "should redirect to listing show page" do
        put :update, :id => @another_listing, :listing => @attr
        response.should redirect_to @another_listing
      end

      it "should have a flash error message" do
        put :update, :id => @another_listing, :listing => @attr
        flash[:error].should =~ /invalid/i
      end

      it "should not change the listing" do
        @before_listing = @another_listing
        put :update, :id => @another_listing, :listing => @attr
        @another_listing.reload
        @another_listing.description.should_not == @attr[:description]
        @another_listing.description.should == @before_listing.description
      end
    end
  end

end
