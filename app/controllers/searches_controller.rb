class SearchesController < ApplicationController
  def index
    @title = "Search"
    @keywords = params[:q].to_s.split(' ');
    @results = Tanker.search([Book, Listing], params[:q])
  end

end
