class ListingsController < ApplicationController
  before_filter :authenticate, :except => [:show, :index]
  before_filter :correct_user, :only => [:edit, :update]

  def index
    @title = "Posts"
    @listings = Listing.all.paginate(:page => params[:page])
  end

  def show
    @listing = Listing.find(params[:id]);
  end

  def new
    @title = 'New Listing'
    @listing = current_user.listings.build
  end

  def create
    @listing = current_user.listings.build(params[:listing])
    if @listing.save
      flash[:success] = "New Listing Posted."
      redirect_to @listing
    else
      @title = "New Listing"
      render 'new'
    end
  end

  def edit
    @title = "Edit | #{@listing.title}"
  end

  def update
    if @listing.update_attributes(params[:listing])
      flash[:success] = "Listing updated."
      redirect_to @listing
    else
      @title = "Edit | #{@listing.title}"
      render 'edit'
    end
  end

  private

    def correct_user
      @listing = Listing.find(params[:id])
      if !current_user?(@listing.user)
        flash[:error] = "Invalid user."
        redirect_to @listing
      end
    end

end
