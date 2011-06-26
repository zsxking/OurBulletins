class BooksController < ApplicationController
  before_filter :authenticate, :only => :create

  def index
    @title = 'Books'
    @books = Book.all.paginate(:page => params[:page])
  end

  def show
    @book = Book.find(params[:id])
  end

  def create
    book = Book.get_from_amazon_by_isbn(params[:isbn])
    if book.nil?
      flash[:error] = "Book not found."
      redirect_to books_path
    end
    if book.save
      redirect_to new_book_listing_path(book)
    else
      flash[:error] = "Book creation failed."
      redirect_to books_path
    end
  end

  def find
    @books = Book::grab_books_amazon(params[:keywords])
    # Check and replace for saved books
    unless @books.nil? || @books.empty?
      @books = @books.map do |book|
        Book.find_by_isbn(book.isbn) || Book.find_by_ean(book.ean) || book
      end
    end
  end

end