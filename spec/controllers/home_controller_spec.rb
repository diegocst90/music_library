require 'spec_helper'

describe HomeController do
  include SharedMethods
  
  describe "Home Page" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect_good_request
    end
    
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
end
