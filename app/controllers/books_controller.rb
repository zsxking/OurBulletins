class BooksController < ApplicationController
  respond_to :js, :html

  def index
    @books = Book.all.paginate(:page => params[:page])
  end

  def show
    @book = Book.find(params[:id])
  end

  def create

  end

  def find
    #@keywords = params[:q].to_s.split(' ');
    @isbn = params[:isbn]
    @book = Book.find_by_isbn(@isbn) || Book.find_by_ean(@isbn)
    respond_to do |format|
      format.html
      format.js {render :layout => nil}
    end

  end

end
