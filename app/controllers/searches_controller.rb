class SearchesController < ApplicationController
  def index
    @title = "Search"
    @keywords = params[:q].to_s.split(' ');
  end

end
