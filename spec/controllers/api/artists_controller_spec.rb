require 'spec_helper'

describe Api::ArtistsController do
  include SharedMethods
  
  describe "REST functions" do
    
    #GET :index
    it "should return all Artists" do
      list_artists = FactoryGirl.create_list :artist, 4
      
      xhr :get, :index
      expect_good_request
      expect_json(:eq, get_list_json_format(list_artists, "artist"))
    end
   
    it "should return an empty array if there isn't any artist registered" do
      xhr :get, :index
      expect_good_request
      expect_json(:eq, [])
    end
    
    #GET :index with :id
    it "should return the info of the artist given by ID" do
      artist = FactoryGirl.create :artist
      
      xhr :get, :show, :id=>artist.id
      expect_good_request
      expect_json(:eq, convert_to_json(artist, "artist"))
    end
    
    it "should return a 422 error if the artist can't be found" do
      xhr :get, :show, :id=>1
      expect_bad_request
    end
    
    #POST :create
    
    it "should not save an artist if all data is incorrect" do
      xhr :post, :create, :artist => {:name=>''}
      expect_bad_request
      expect_json(:include, {
          "errors"=>{
            "name"=>[I18n.t('errors.messages.blank')]
          }
        })
    end
    
    it "should save an artist if all data is correct" do
      xhr :post, :create, :artist => FactoryGirl.attributes_for(:artist)
      expect_good_request
    end
    
    it "should return the json result of the artist created" do
      new_attributes = FactoryGirl.attributes_for(:artist)
      xhr :post, :create, :artist => new_attributes

      expect_json(:include, convert_to_json(new_attributes, "artist"))
    end
    
    #PUT :update
    it "should not update an artist if it doesn't exist" do
      xhr :put, :update, :id=>1, :artist => FactoryGirl.attributes_for(:artist)
      expect_bad_request
    end
    
    it "should not update an artist if all data is incorrect" do
      FactoryGirl.create(:artist, :defined_name)
      artist1 = FactoryGirl.create(:artist)
      
      xhr :put, :update, :id=>artist1.id, :artist => FactoryGirl.attributes_for(:artist, :defined_name)
      expect_bad_request
      expect_json(:include, {
          "errors"=>{
            "name"=>[I18n.t('activerecord.errors.messages.taken')]
          }
        })
    end
    
    it "should update an artist if all data is correct" do
      artist = FactoryGirl.create(:artist)
      new_attributes = FactoryGirl.attributes_for(:artist, :defined_name)
      xhr :put, :update, :id=>artist.id, :artist => new_attributes
      expect_good_request
      expect_json(:include, {
          "name"=>new_attributes[:name]
        })
    end
    
    #DELETE :destroy
    it "should not delete an inexistent artist" do
      xhr :delete, :destroy, :id=>1
      expect_bad_request
    end
    
    it "should delete a valid artist passed by ID" do
      artist = FactoryGirl.create :artist
      
      xhr :delete, :destroy, :id=>artist.id
      expect_good_request
    end
  end
end
