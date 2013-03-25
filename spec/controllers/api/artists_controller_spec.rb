require 'spec_helper'

describe Api::ArtistsController do
  include SharedMethods
  
  #Convert an Artist object to json. Used by get_list_json_format
  def convert_to_json(artist)
    {"created_at"=>artist.created_at.to_json.gsub("\"",""), "deleted"=>false, "id"=>artist.id, "name"=>artist.name, "updated_at"=>artist.updated_at.to_json.gsub("\"","")}
  end
  
  describe "REST functions" do
    
    #GET :index
    it "should return all Artists" do
      @artist1 = Artist.create(name: "Demo artist1")
      @artist2 = Artist.create(name: "Demo artist2")
      @artist3 = Artist.create(name: "Demo artist3")
      @artist4 = Artist.create(name: "Demo artist4")
      
      get :index, :format => :json
      expect_good_request
      expect_json(:eq, get_list_json_format([@artist1, @artist2, @artist3, @artist4]))
    end
   
    it "should return an empty array if there isn't any artist registered" do
      get :index, :format => :json
      expect_good_request
      expect_json(:eq, [])
    end
    
    #GET :index with :id
    it "should return the info of the artist given by ID" do
      @artist = Artist.create(name: "Demo artist")
      
      get :show, :id=>@artist.id, :format => :json
      expect_good_request
      expect_json(:eq, convert_to_json(@artist))
    end
    
    it "should return a 422 error if the artist can't be found" do
      get :show, :id=>1, :format => :json
      expect_bad_request
    end
    
    #POST :create
    
    it "should not save an artist if all data is incorrect" do
      post :create, :artist => {:name=>''}, :format => :json
      expect_bad_request
      expect_json(:include, {
          "errors"=>{
            "name"=>[I18n.t('errors.messages.blank')]
          }
        })
    end
    
    it "should not save a duplicated artist" do
      @artist = Artist.create!(name: "Demo artist1")
      
      ["Demo artist1","DEMO ARTIST1"].each do |duplicated_name|
        post :create, :artist => {:name=>duplicated_name}, :format => :json
        expect_bad_request
        expect_json(:include, {
            "errors"=>{
              "name"=>[I18n.t('activerecord.errors.messages.taken')]
            }
          })
      end
    end
    
    it "should save an artist if all data is correct" do
      post :create, :artist => {:name=>'Artist name'}, :format => :json
      expect_good_request
    end
    
    #PUT :update
    it "should not update an artist if it doesn't exist" do
      put :update, :id=>1, :artist => {:name=>"New name"}, :format => :json
      expect_bad_request
    end
    
    it "should not update an artist if all data is incorrect" do
      @artist1 = Artist.create(name: "Demo artist1")
      @artist2 = Artist.create(name: "Demo artist2")
      
      put :update, :id=>@artist2.id, :artist => {:name=>"Demo artist1"}, :format => :json
      expect_bad_request
      expect_json(:include, {
          "errors"=>{
            "name"=>[I18n.t('activerecord.errors.messages.taken')]
          }
        })
    end
    
    it "should not updated to a duplicated artist" do
      @artist1 = Artist.create!(name: "Demo artist1")
      @artist2 = Artist.create!(name: "Demo artist2")
      
      ["Demo artist2", "DEMO ARTIST2"].each do |duplicated_name|
        put :update, :id=>@artist1.id, :artist => {:name=>duplicated_name}, :format => :json
        expect_bad_request
        expect_json(:include, {
            "errors"=>{
              "name"=>[I18n.t('activerecord.errors.messages.taken')]
            }
          })
      end
    end
    
    it "should update an artist if all data is correct" do
      @artist = Artist.create(name: "Demo artist")
      
      put :update, :id=>@artist.id, :artist => {:name=>"Updated name"}, :format => :json
      expect_good_request
      expect_json(:include, {
          "name"=>"Updated name"
        })
    end
    
    #DELETE :destroy
    it "should not delete an inexistent artist" do
      delete :destroy, :id=>1, :format=> :json
      expect_bad_request
    end
    
    it "should delete a valid artist passed by ID" do
      @artist = Artist.create(name: "Demo artist")
      
      delete :destroy, :id=>@artist.id, :format=> :json
      expect_good_request
    end
  end
end
