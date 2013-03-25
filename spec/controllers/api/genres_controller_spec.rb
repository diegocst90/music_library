require 'spec_helper'

describe Api::GenresController do
  include SharedMethods
  
  #Convert a Genre object to json. Used by get_list_json_format
  def convert_to_json(genre)
    {"created_at"=>genre.created_at.to_json.gsub("\"",""), "deleted"=>false, "description"=>genre.description, "id"=>genre.id, "name"=>genre.name, "updated_at"=>genre.updated_at.to_json.gsub("\"","")}
  end
  
  describe "REST functions" do
    
    #GET :index
    it "should return all Genres" do
      @genre1 = Genre.create(name: "Demo genre1", :description=>"Description1")
      @genre2 = Genre.create(name: "Demo genre2", :description=>"Description2")
      @genre3 = Genre.create(name: "Demo genre3", :description=>"Description3")
      @genre4 = Genre.create(name: "Demo genre4", :description=>"Description4")
      
      get :index, :format => :json
      expect_good_request
      expect_json(:eq, get_list_json_format([@genre1, @genre2, @genre3, @genre4]))
    end
   
    it "should return an empty array if there isn't any genre registered" do
      get :index, :format => :json
      expect_good_request
      expect_json(:eq, [])
    end
    
    #GET :index with :id
    it "should return the info of the genre given by ID" do
      @genre = Genre.create(name: "Demo genre", description: "Description")
      
      get :show, :id=>@genre.id, :format => :json
      expect_good_request
      expect_json(:eq, convert_to_json(@genre))
    end
    
    it "should return a 422 error if the genre can't be found" do
      get :show, :id=>1, :format => :json
      expect_bad_request
    end
    
    #POST :create
    
    it "should not save a genre if all data is incorrect" do
      post :create, :genre => {:name=>''}, :format => :json
      expect_bad_request
      expect_json(:include, {
          "errors"=>{
            "name"=>[I18n.t('errors.messages.blank')]
          }
        })
    end
    
    it "should not save a duplicated genre" do
      @genre = Genre.create!(name: "Demo genre1", description: "Description1")
      
      ["Demo genre1","DEMO GENRE1"].each do |duplicated_name|
        post :create, :genre => {:name=>duplicated_name, description: "Description1"}, :format => :json
        expect_bad_request
        expect_json(:include, {
            "errors"=>{
              "name"=>[I18n.t('activerecord.errors.messages.taken')]
            }
          })
      end
    end
    
    it "should save an genre if all data is correct" do
      post :create, :genre => {:name=>'Genre name', description: "Description"}, :format => :json
      expect_good_request
    end
    
    #PUT :update
    it "should not update an genre if it doesn't exist" do
      put :update, :id=>1, :genre => {:name=>"New name", description: "Description"}, :format => :json
      expect_bad_request
    end
    
    it "should not update an genre if all data is incorrect" do
      @genre1 = Genre.create(name: "Demo genre1")
      @genre2 = Genre.create(name: "Demo genre2")
      
      put :update, :id=>@genre2.id, :genre => {:name=>"Demo genre1", description: "Description"}, :format => :json
      expect_bad_request
      expect_json(:include, {
          "errors"=>{
            "name"=>[I18n.t('activerecord.errors.messages.taken')]
          }
        })
    end
    
    it "should not updated to a duplicated genre" do
      @genre1 = Genre.create!(name: "Demo genre1")
      @genre2 = Genre.create!(name: "Demo genre2")
      
      ["Demo genre2", "DEMO GENRE2"].each do |duplicated_name|
        put :update, :id=>@genre1.id, :genre => {:name=>duplicated_name, description: "Description"}, :format => :json
        expect_bad_request
        expect_json(:include, {
            "errors"=>{
              "name"=>[I18n.t('activerecord.errors.messages.taken')]
            }
          })
      end
    end
    
    it "should update an genre if all data is correct" do
      @genre = Genre.create(name: "Demo genre")
      
      put :update, :id=>@genre.id, :genre => {:name=>"Updated name", description: "Description"}, :format => :json
      expect_good_request
      expect_json(:include, {
          "name"=>"Updated name"
        })
    end
    
    #DELETE :destroy
    it "should not delete an inexistent genre" do
      delete :destroy, :id=>1, :format=> :json
      expect_bad_request
    end
    
    it "should delete a valid genre passed by ID" do
      @genre = Genre.create(name: "Demo genre", description: "Description")
      
      delete :destroy, :id=>@genre.id, :format=> :json
      expect_good_request
    end
  end
end
