require 'spec_helper'

describe BooksController do
  render_views

  describe "Authentication" do
    describe "for non-logged in user" do
      it "should deny access to create" do
        post :create
        response.should redirect_to(login_path)
      end
    end
  end

  describe "GET 'index'" do
    before(:each) do
      @book = Factory(:book)
      @book2 = Factory(:book, :title => 'New Book',
                       :ean => 1234567890000, :isbn => 1234567899)
    end

    it "should be successful" do
      get :index
      response.should be_success
    end

    it "should have the right title" do
      get :index
        response.should have_selector("title", :content => "Books")
    end

    it "should have books with links" do
      get :index
      response.should have_selector("a", :content => @book.title,
                                    :href => "/books/#{@book.id}")
      response.should have_selector("a", :content => @book2.title,
                                    :href => "/books/#{@book2.id}")
    end
  end

  describe "GET 'show'" do

    before(:each) do
      @book = Factory(:book)
      @user = Factory(:user)
      @listing = Factory(:listing, :user => @user, :saleable => @book)
      @listing2 = Factory(:listing, :user => @user, :saleable => @book)
    end

    it "should be successful" do
      get :show, :id => @book
      response.should be_success
    end

    it "should show book's title" do
      get :show, :id => @book
      response.should have_selector('div', :content => @book.title)
    end

    it "should show listings of this book" do
      get :show, :id => @book
      response.should have_selector("a", :href => "/listings/#{@listing.id}")
      response.should have_selector("a", :href => "/listings/#{@listing2.id}")
    end

    it 'should show the list button even when not logged in.' do
      get :show, :id => @book
      response.should have_selector('input[type="submit"]',
                                    :value => 'List this book')
    end
  end

  describe "GET 'find'" do
    it "should be successful" do
      xhr :get, :find
      response.should be_success
    end

    describe 'with empty keywords' do
      it 'should return proper message' do
        xhr :get, :find
        response.should contain('not match any')
      end
    end

    describe 'with some key words' do
      it 'should return books' do
        xhr :get, :find, :keywords => 'brain rules'
        response.should have_selector('.title', :content => 'Brain Rules')
      end

      it 'should contain proper button to create book' do
        xhr :get, :find, :keywords => '9780979777745'
        response.should have_selector('form', :action => books_path, :method => 'post')
        response.should have_selector('input[name="isbn"][type="hidden"]', :value => '9780979777745')
        response.should have_selector('input[type="submit"]', :value => "List this book")
      end

      describe 'on existed books' do
        before(:each) do
          @book = Book.get_from_amazon_by_isbn(9780979777745)
          @book.save!
        end

        it 'should return the book with proper link' do
          xhr :get, :find, :keywords => @book.ean
          response.should have_selector('.title a', :content => @book.title)
        end

        it 'should contain proper button to create book' do
          xhr :get, :find, :keywords => @book.ean
          response.should have_selector('form', :method => 'get',
                                        :action => new_book_listing_path(@book))
        end
      end
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @user = Factory(:user)
      test_login(@user)
    end

    describe "failure" do
      it "should not create a book" do
        lambda do
          post :create, :isbn => '1234'
        end.should_not change(Book, :count)
      end

      it "should redirect back to books index" do
        post :create, :isbn => '1234'
        response.should redirect_to books_path
        flash[:error].should contain('Book not found')
      end
    end

    describe "success" do
      it "should create a listing" do
        lambda do
          post :create, :isbn => 9780979777745
        end.should change(Book, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :isbn => 9780979777745
        response.should redirect_to(new_book_listing_path(assigns(:book)))
      end
    end
  end

end
