require 'spec_helper'

describe PostsController do
  render_views

  describe "Authentication" do

    before(:each) do
      @user = Factory(:user)
      @post = Factory(:post, :user => @user)
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
        put :update, :id => @post
        response.should redirect_to(login_path)
      end

      it "should deny access to edit" do
        get :edit, :id => @post
        response.should redirect_to(login_path)
      end
    end

  end

  describe "GET 'index'" do

    it "should be successful" do
      get :index
      response.should be_success
    end

    it "should show posts" do
      user1 = Factory(:user)
      user2 = Factory(:user, :email => Factory.next(:email))
      post1 = Factory(:post, :user => user1)
      post2 = Factory(:post, :user => user2)
      get :index
      response.should have_selector("div.title", :content => post1.title)
      response.should have_selector("div.title", :content => post2.title)
    end

  end

  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
      @post = Factory(:post, :user => @user)
      @user2 = Factory(:user, :email => Factory.next(:email))
    end

    it "should be successful" do
      get :show, :id => @post
      response.should be_success
    end

    it "should show post's title" do
      get :show, :id => @post
      response.should have_selector('div', :content => @post.title)
    end

    it "should show edit link when login as owner" do
      test_login(@user)
      get :show, :id => @post
      response.should have_selector('a', :content => 'Edit')
    end

    it "should not show edit link when not login" do
      get :show, :id => @post
      response.should_not have_selector('a', :content => 'Edit')
    end

    it "should not show edit link when login as others" do
      test_login(@user2)
      get :show, :id => @post
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
      response.should have_selector("title", :content => 'New Post')
    end

    it "should have the Sign up button" do
      get :new
      response.should have_selector("input[value='Post']")
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @user = Factory(:user)
      test_login(@user)
    end
  describe "failure" do

      before(:each) do
        @attr = {:title => '', :category => '',
                :description => ''}
      end

      it "should not create a user" do
        lambda do
          post :create, :post => @attr
        end.should_not change(@user.posts, :count)
      end

      it "should render the 'new' page" do
        post :create, :post => @attr
        response.should render_template('new')
      end
    end

    describe "success" do

      before(:each) do
        @attr = {:title => 'Post Title', :category => 'Cat',
                :description => 'Description content'}
      end

      # Cannot use response.should be_success,
      # because it returns true if the response code is in the range 200-299.
      # But the create action redirects, so the response code gets set to 302,
      # thus the failure
      it "should create a user" do
        lambda do
          post :create, :post => @attr
        end.should change(@user.posts, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :post => @attr
        response.should redirect_to(post_path(assigns(:post)))
      end

    end

  end

  describe "GET 'edit'" do
    before(:each) do
      @user = Factory(:user)
      @post = Factory(:post, :user => @user)
      test_login(@user)
    end

    it "should be successful" do
      get :edit, :id => @post
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @post
      response.should have_selector("title", :content => "Edit")
      response.should have_selector("title", :content => @post.title)
    end

    describe "on other's post" do
      before (:each) do
        @another_user = Factory(:user, :email => Factory.next(:email))
        @another_post = Factory(:post, :user => @another_user)
      end

      it "should redirect to post show page" do
        get :edit, :id => @another_post
        response.should redirect_to @another_post
      end

      it "should have a flash error message" do
        put :update, :id => @another_post, :post => @attr
        flash[:error].should =~ /invalid/i
      end

    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @user = Factory(:user)
      @post = Factory(:post, :user => @user)
      test_login(@user)
    end


    describe "failure" do

      before(:each) do
        @attr = {:title => '', :category => '',
                :description => ''}
      end

      it "should render the 'edit' page" do
        put :update, :id => @post, :post => @attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @post, :post => @attr
        response.should have_selector("title", :content => "Edit")
      end
    end

    describe "success" do

      before(:each) do
        @attr = {:title => 'New Title', :category => 'New Cat',
                :description => 'New Descriptions'}
      end

      it "should change the post's description" do
        put :update, :id => @post, :post => @attr
        @post.reload
        @post.description.should == @attr[:description]
      end

      it "should redirect to the post show page" do
        put :update, :id => @post, :post => @attr
        response.should redirect_to @post
      end

      it "should have a flash message" do
        put :update, :id => @post, :post => @attr
        flash[:success].should =~ /updated/i
      end
    end

    describe "on other's post" do
      before (:each) do
        @another_user = Factory(:user, :email => Factory.next(:email))
        @another_post = Factory(:post, :user => @another_user)
        @attr = {:title => 'New Title', :category => 'New Cat',
                :description => 'New Descriptions'}
      end

      it "should redirect to post show page" do
        put :update, :id => @another_post, :post => @attr
        response.should redirect_to @another_post
      end

      it "should have a flash error message" do
        put :update, :id => @another_post, :post => @attr
        flash[:error].should =~ /invalid/i
      end

      it "should not change the post" do
        @before_post = @another_post
        put :update, :id => @another_post, :post => @attr
        @another_post.reload
        @another_post.category.should_not == @attr[:category]
        @another_post.description.should_not == @attr[:description]
        @another_post.category.should == @before_post.category
        @another_post.description.should == @before_post.description
      end
    end
  end

end
