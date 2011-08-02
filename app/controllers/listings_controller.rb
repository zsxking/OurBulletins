class ListingsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  before_filter :correct_user, :only => [:edit, :update]

  def index
    @title = "Others"
    @listings = Listing.other.page(params[:page])
  end

  def show
    @listing = Listing.find(params[:id])
  end

  def new
    @title = 'New Listing'
    @listing = current_user.listings.build
    @listing.saleable = find_saleable
  end

  def create
    @listing = current_user.listings.build(params[:listing])
    @listing.saleable = find_saleable
    if @listing.save
      flash[:success] = "New Listing Posted."
      redirect_to @listing
    else
      @title = "New Listing"
      render 'new'
    end
  end

  def edit
    #@listing = current_user.listings.find(params[:id])
    @title = "Edit | #{@listing.title}"
  end

  def update
    #@listing = current_user.listings.find(params[:id])
    if @listing.update_attributes(params[:listing])
      flash[:success] = "Listing updated."
      redirect_to @listing
    else
      @title = "Edit | #{@listing.title}"
      render 'edit'
    end
  end

  def new_reply
    @listing = Listing.find(params[:id])
    @reply = @listing.replies.new
    @reply.user = current_user
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create_reply
    @listing = Listing.find(params[:id])
    @reply = @listing.replies.build(params[:reply])
    @reply.user = current_user
    # Sent email here.
    ListingMailer.reply_listing(@reply).deliver

    if (@reply.save)
      flash[:success] = 'Reply was successfully sent.'
    else
      flash[:error] = 'Internal error, please try again later.'
    end

    respond_to do |format|
      format.html { redirect_to @listing }
      format.js
    end

  end

  private

    def correct_user
      @listing = Listing.find(params[:id])
      if !(current_user == @listing.user)
        flash[:error] = "Invalid user."
        redirect_to @listing
      end
    end

    def find_saleable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
end

end
