require 'spec_helper'

describe Book do
  before(:each) do
    @isbn = 9781933988658
    @book_attr = {
            :title => 'The Well-Grounded Rubyist',
            :author => 'David A. Black',
            :isbn => '1933988657',
            :ean => '9781933988658',
            :publish_date => '2009-06-04',
            :publisher => 'Manning Publications',
            :edition => '1',
            :list_price => 44.99
    }
  end

  it 'should create a new instance given valid attributes' do
    Book.create!(@book_attr)
  end

  describe "amazon api" do
    describe "get_from_amazon_by_isbn" do
      before(:each) do
        @book = Book::get_from_amazon_by_isbn(@isbn)
      end

      it 'should return a book object' do
        @book.should be_an_instance_of Book
      end

      it 'should return the correct book' do
        @book.title.should == @book_attr[:title]
        @book.author.should == @book_attr[:author]
        @book.ean.should == @book_attr[:ean]
        @book.isbn.should == @book_attr[:isbn]
        @book.publish_date.should == @book_attr[:publish_date]
        @book.publisher.should == @book_attr[:publisher]
        @book.edition.should == @book_attr[:edition]
        @book.list_price.should == @book_attr[:list_price]
        @book.description.should_not be_nil
        @book.image_link.should_not be_nil
        @book.icon_link.should_not be_nil
        @book.amazon_detail_url.should_not be_nil
      end
    end

    describe 'grab_books_amazon' do

      before(:each) do
        @books = Book.grab_books_amazon('Brain Rules')
      end

      it 'should return multiple unsaved Book objects' do
        @books.length.should > 2
        @books.each do |book|
          book.should be_an_instance_of Book
          book.new_record?.should be_true
        end
      end

      describe 'on saved book' do
        before (:each) do
          @book = @books[0]
          @book.save!
        end

        it 'should not return the saved book' do
          books = Book.grab_books_amazon('Brain Rules')
          books[0].should_not == @book
          books[0].new_record?.should be_true
        end
      end
    end
  end

  describe "save book" do

    it 'should save the book correctly' do
      book = Book.create!(@book_attr)
      book.reload
      book.title.should == @book_attr[:title]
      book.author.should == @book_attr[:author]
      book.ean.should == @book_attr[:ean]
      book.isbn.should == @book_attr[:isbn]
      book.publish_date.should == @book_attr[:publish_date]
      book.publisher.should == @book_attr[:publisher]
      book.edition.should == @book_attr[:edition]
      book.list_price.should == @book_attr[:list_price]
    end
  end

  describe 'listing association' do
    before(:each) do
      @user = Factory(:user)
      @book = Book.create!(@book_attr)
      @listing = Factory(:listing, :user => @user, :price => 12.34)
      @listing.saleable = @book
      @listing.save
      @listing2 = Factory(:listing, :user => @user, :price => 56.78)
      @listing2.saleable = @book
      @listing2.save
    end

    it 'should response to listings' do
      @book.should respond_to :listings
    end

    it 'should have the right associated listings' do
      @book.listings.should =~ [@listing, @listing2]
    end

    it 'should return correct lowest price' do
      @book.lowest_price.should == 12.34
    end

  end

end
