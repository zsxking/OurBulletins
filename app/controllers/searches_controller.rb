class SearchesController < ApplicationController
  def index
    @title = "Search"
    @keywords = params[:q].to_s.split(' ')
    @model = params[:cat] ? params[:cat].classify.constantize : Book
    @results = @model.search_tank(params[:q])
  end

end
