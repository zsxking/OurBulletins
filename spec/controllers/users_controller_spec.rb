require 'spec_helper'
require 'factories'

describe UsersController do
  render_views

  describe "GET 'index'" do

    describe "for non-logged-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(login_path)
        flash[:notice].should =~ /login/i
      end
    end

    describe "for logged_in users" do

      before(:each) do
        @user = test_login(Factory(:user))
        second = Factory(:user, :name => "Bob", :email => "second@example.edu")
        third  = Factory(:user, :name => "Ben", :email => "third@example.edu")

        @users = [@user, second, third]
        30.times do
          #  Array push notation <<
          @users << Factory(:user, :email => Factory.next(:email))
        end
      end

      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "Users")
      end

      it "should have an element for each user" do
        get :index
        @users[0..2].each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end

      it "should paginate users" do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "2")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "Next")
      end

    end
  end

  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
      @login_user = Factory(:user, :email => 'new@user.edu')
      test_login(@login_user)
      # stubbing with the stub! method.
      # User.stub!(:new, @user.id).and_return(@user)
    end

    it "should be successful" do
      get :show, :id => @user # same as @user.id, because Rails will convert it.
      response.should be_success
    end

    it "should new the right user" do
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

    it "should show edit link on login user's profile page." do
      get :show, :id => @login_user
      response.should have_selector('a', :content => 'Edit')
    end

    it "should not show edit link on other profile page." do
      get :show, :id => @user
      response.should_not have_selector('a', :content => 'Edit')
    end

  end

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => 'Sign Up')
    end

    it "should have the Sign up button" do
      get :new
      response.should have_selector("input[value='Sign up']")
    end

  end

  describe "POST 'create'" do

    describe "failure" do

      before(:each) do
        @attr = { :name => "", :email => "", :password => "1234",
                  :password_confirmation => "4321" }
      end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :name => "New User", :email => "user@university.edu",
                  :password => "ASdf1234", :password_confirmation => "ASdf1234" }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome/i # =~ to compare string to regex.
      end

      it "should log the user in" do
        post :create, :user => @attr
        controller.should be_logged_in
      end
    end

  end

  describe "GET 'edit'" do

    before(:each) do
      @user = Factory(:user)
      test_login(@user)
    end

    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit user")
    end

    it "should have the Update button" do
      get :edit, :id => @user
      response.should have_selector("input[value='Update']")
    end

    it "should have information filled in" do
      get :edit, :id => @user
      response.should have_selector("input[name='user[name]'][value='#{@user.name}']")
      response.should have_selector("input[name='user[email]'][value='#{@user.email}']")
    end

  end

  describe "PUT 'update'" do

    before(:each) do
      @user = Factory(:user)
      test_login(@user)
    end

    describe "failure" do

      before(:each) do
        @attr = { :email => "", :name => "", :password => "",
                  :password_confirmation => "" }
      end

      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edit user")
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :name => "New Name", :email => "user@newmail.edu",
                  :password => "newpwd1234", :password_confirmation => "newpwd1234" }
      end

      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should  == @attr[:name]
        @user.email.should == @attr[:email]
      end

      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end

      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/
      end
    end
  end

  describe "authentication of edit/update/deactivate/ban pages" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "for non-logged_in users" do

      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(login_path)
      end

      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(login_path)
      end

      it "should deny access to 'deactivate'" do
        put :deactivate, :id => @user
        response.should redirect_to(login_path)
      end

      it "should deny access to 'ban'" do
        put :ban, :id => @user
        response.should redirect_to(login_path)
      end

    end

    describe "for logged_in users" do

      before(:each) do
        @login_user = Factory(:user, :email => "user@wrong.edu")
        test_login(@login_user)
      end

      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        flash[:error].should =~ /invalid/i
        response.should redirect_to(root_path)
      end

      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        flash[:error].should =~ /invalid/i
        response.should redirect_to(root_path)
      end

      it "should require matching users for 'deactivate'" do
        put :deactivate, :id => @user
        flash[:error].should =~ /invalid/i
        response.should redirect_to(root_path)
      end

    end
  end

  describe "PUT 'deactivate'" do
    before(:each) do
      @user = Factory(:user)
      test_login(@user)
    end

    it "should reduce user count on default scope" do
      lambda do
        put :deactivate, :id => @user
      end.should change(User, :count).by(-1)
    end

    it "should deactivate the user" do
      put :deactivate, :id => @user
      @user.reload
      @user.status.should == UserStatus::DEACTIVATED
    end

    it "should redirect to home page" do
      put :deactivate, :id => @user
      response.should redirect_to(root_path)
    end

    it "should log user out" do
      put :deactivate, :id => @user
      controller.should_not be_logged_in
    end
  end


  describe "PUT 'ban'" do
    before(:each) do
      @user = Factory(:user)
      @admin_user = Factory(:admin)
      test_login(@admin_user)
    end

    it "should require admin" do
      test_login(@user)
      put :ban, :id => @user
      flash[:error].should =~ /invalid/i
      response.should redirect_to(root_path)
    end

    describe "on normal user" do
      it "should reduce user count on default scope" do
        lambda do
          put :ban, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "should ban the user" do
          put :ban, :id => @user
        @user.reload.status.should == UserStatus::BANNED
      end

      it "should redirect to user list" do
        put :ban, :id => @user
        response.should redirect_to users_path
      end
    end

    describe "on admin user" do
      it "should not affect user count" do
        lambda do
          put :ban, :id => @admin_user
        end.should_not change(User, :count)
      end
      it "should not affect the user" do
        put :ban, :id => @admin_user
        @admin_user.status.should == UserStatus::ACTIVE
      end

      it "should have fail message" do
        put :ban, :id => @admin_user
        flash[:error].should =~ /invalid action/i
      end

    end

  end

end