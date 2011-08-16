require 'spec_helper'

describe SearchesController do
  render_views

  describe "GET 'index'" do
    it "should have the right title" do
      get :index
      response.should have_selector('title', :content => 'Search')
    end
  end

end
