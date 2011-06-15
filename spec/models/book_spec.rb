require 'spec_helper'

describe Book do
  before(:each) do
    @isbn = 9781933988658
    @book_attr = {
            :title => 'The Well-Grounded Rubyist',
            :author => 'David A. Black',
            :isbn => '9781933988658',
            :ean => '9781933988658',
            :publish_date => '2009-06-04',
            :publisher => 'Manning Publications',
            :edition => '1',
            :list_price => 4499
    }
  end

  describe "get book from amazon api" do
    before(:each) do
      @books = Book::get_from_amazon_by_isbn(@isbn)
    end

    it 'should return one book' do
      @books.length.should == 1
    end

    it 'should return the correct book' do
      book = @books[0]
      book.title.should == @book_attr[:title]
      book.author.should == @book_attr[:author]
      book.ean.should == @book_attr[:ean]
      book.isbn.should == @book_attr[:isbn]
      book.publish_date.should == @book_attr[:publish_date]
      book.publisher.should == @book_attr[:publisher]
      book.edition.should == @book_attr[:edition]
      book.list_price.should == @book_attr[:list_price]
      book.description.should_not be_nil
      book.image_link.should_not be_nil
      book.amazon_detail_url.should_not be_nil
    end
  end

  describe "save book" do

    it "should save the book correctly" do
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

  describe "polymorphic association" do
    before(:each) do
      @book = Book.create!(@book_attr)
    end

    it "should response to listings" do
      @book.should respond_to :listings
    end

  end

end
