require 'spec_helper'

describe Api::GenresController do
  include SharedMethods
  
  describe "REST functions" do
    
    #GET :index
    it "should return all Genres" do
      list_genres = FactoryGirl.create_list :genre, 4
      
      xhr :get, :index
      expect_good_request
      expect_json(:eq, get_list_json_format(list_genres, "genre"))
    end
   
    it "should return an empty array if there isn't any genre registered" do
      xhr :get, :index
      expect_good_request
      expect_json(:eq, [])
    end
    
    #GET :index with :id
    it "should return the info of the genre given by ID" do
      genre = FactoryGirl.create :genre
      
      xhr :get, :show, :id=>genre.id
      expect_good_request
      expect_json(:eq, convert_to_json(genre, "genre"))
    end
    
    it "should return a 422 error if the genre can't be found" do
      xhr :get, :show, :id=>1
      expect_bad_request
    end
    
    #POST :create
    
    it "should not save a genre if all data is incorrect" do
      xhr :post, :create, :genre => {:name=>''}
      expect_bad_request
      expect_json(:include, {
          "errors"=>{
            "name"=>[I18n.t('errors.messages.blank')]
          }
        })
    end
    
    it "should save an genre if all data is correct" do
      xhr :post, :create, :genre => FactoryGirl.attributes_for(:genre)
      expect_good_request
    end
    
    it "should return the json result of the genre created" do
      new_attributes = FactoryGirl.attributes_for(:genre)
      xhr :post, :create, :genre => new_attributes

      expect_json(:include, convert_to_json(new_attributes, "genre"))
    end
    
    #PUT :update
    it "should not update an genre if it doesn't exist" do
      xhr :put, :update, :id=>1, :genre => FactoryGirl.attributes_for(:genre)
      expect_bad_request
    end
    
    it "should not update an genre if all data is incorrect" do
      FactoryGirl.create(:genre, :defined_name)
      genre1 = FactoryGirl.create(:genre)
      
      xhr :put, :update, :id=>genre1.id, :genre => FactoryGirl.attributes_for(:genre, :defined_name)
      expect_bad_request
      expect_json(:include, {
          "errors"=>{
            "name"=>[I18n.t('activerecord.errors.messages.taken')]
          }
        })
    end
    
    it "should update an genre if all data is correct" do
      genre = FactoryGirl.create(:genre)
      new_attributes = FactoryGirl.attributes_for(:genre, :defined_name)
      xhr :put, :update, :id=>genre.id, :genre => new_attributes
      expect_good_request
      expect_json(:include, {
          "name"=>new_attributes[:name]
        })
    end
    
    #DELETE :destroy
    it "should not delete an inexistent genre" do
      xhr :delete, :destroy, :id=>1
      expect_bad_request
    end
    
    it "should delete a valid genre passed by ID" do
      genre = FactoryGirl.create :genre
      
      xhr :delete, :destroy, :id=>genre.id
      expect_good_request
    end
  end
end
