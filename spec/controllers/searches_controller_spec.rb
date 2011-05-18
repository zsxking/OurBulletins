require 'spec_helper'

describe SearchesController do
  render_views

  describe "GET 'index'" do
    it "should have the right title" do
      get :index
      response.should have_selector('title', :content => 'Search')
    end

    it "should preserve user input" do
      search_phrase = 'Search -Phrase'
      get :index, :q => search_phrase
      response.should have_selector("input[value='#{search_phrase}']")
    end
  end

end
