require 'spec_helper'

describe HomeController do
  describe "Home Page" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response.code).to eq("200")
    end
    
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
end
